//
//  FirebaseController.swift
//  lab03
//
//  Created by Saauren Mankad on 12/4/2022.
//

import UIKit

import Firebase
import FirebaseFirestoreSwift

class FirebaseController: NSObject, DatabaseProtocol {
    
    
    let DEFAULT_TEAM_NAME = "Default Team"
    var listeners = MulticastDelegate<DatabaseListener>()
    var heroList: [Superhero] = []
    var defaultTeam: Team
    
    // reference to firebase auth system
    var authController: Auth
    var database: Firestore
    var heroesRef: CollectionReference?
    var teamsRef: CollectionReference?
    var currentUser: FirebaseAuth.User?
    
    
    override init() {
        
        // initialise firebase
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        heroList = [Superhero]()
        defaultTeam = Team()
        super.init()

        // anonymous sign in
        Task {
            do {
                let authDataResult = try await authController.signInAnonymously()
                currentUser = authDataResult.user
            }
            catch {
                // sign in failed
                fatalError("Firebase Authentication Failed with Error \(String(describing: error))")
            }
            
            // sign in success
            self.setupHeroListener()
            
        }
        
    }
    
    func cleanup() {
        print("cleanup")
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == .team || listener.listenerType == .all {
            listener.onTeamChange(change: .update, teamHeroes: defaultTeam.heroes)
        }
        
        if listener.listenerType == .heroes || listener.listenerType == .all {
            listener.onAllHeroesChange(change: .update, heroes: heroList)
        }


    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)

    }
    
    func addSuperhero(name: String, abilities: String, universe: Universe) -> Superhero {
        let hero = Superhero()
        hero.name = name
        hero.abilities = abilities
        hero.universe = universe.rawValue
        
        // attempt to add hero to firestore
        
        do {
            if let heroRef = try heroesRef?.addDocument(from: hero) {
                hero.id = heroRef.documentID
            }
        } catch {
            print("Failed to serialize hero")
        }
        
        return hero
    }
    
    func deleteSuperhero(hero: Superhero) {
        if let heroID = hero.id {
            heroesRef?.document(heroID).delete()
        }
    }
    
    func addTeam(teamName: String) -> Team {
        let team = Team()
        team.name = teamName
        if let teamRef = teamsRef?.addDocument(data: ["name":teamName]) {
            team.id = teamRef.documentID
        }
        return team
        
    }
    
    func deleteTeam(team: Team) {
        if let teamID = team.id {
            teamsRef?.document(teamID).delete()
        }
    }
    
    func addHeroToTeam(hero: Superhero, team: Team) -> Bool {
        guard let heroID = hero.id, let teamID  = team.id, team.heroes.count < 6 else {
            return false
        }
        
        if let newHeroRef = heroesRef?.document(heroID) {
            teamsRef?.document(teamID).updateData(
                ["heroes": FieldValue.arrayUnion([newHeroRef])]
            )
        }
        
        return true
    }
    
    func removeHeroFromTeam(hero: Superhero, team: Team) {
        if team.heroes.contains(hero), let teamID = team.id, let heroID = hero.id {
            
            if let removedHeroRef = heroesRef?.document(heroID) {
                teamsRef?.document(teamID).updateData(
                    ["heroes":FieldValue.arrayRemove([removedHeroRef])]
                )
            }
            
        }
    }
    

    // firebase methods
    func getHeroByID(_ id: String) -> Superhero? {
        for hero in heroList {
            if hero.id == id {
                return hero
            }
        }
        return nil
    }
    
    
    func setupHeroListener() {
        heroesRef = database.collection("superheroes")
        heroesRef?.addSnapshotListener() {
            (querySnapshot, error) in
         
            guard let querySnapshot = querySnapshot else {
                print("Failed to fetch documents with error: \(String(describing: error))")
                return
            }
            self.parseHeroesSnapshot(snapshot: querySnapshot)
            
            if self.teamsRef == nil {
                self.setupTeamListener()
            }
            
        }
        
    }
    func setupTeamListener() {
        teamsRef = database.collection("teams")
        teamsRef?.whereField("name", isEqualTo: DEFAULT_TEAM_NAME).addSnapshotListener {
            (querySnapshot, error) in
            
            guard let querySnapshot = querySnapshot, let teamSnapshot = querySnapshot.documents.first else {
                print("Error fetching teams: \(error!)")
                return
            }
            
            self.parseTeamSnapshot(snapshot: teamSnapshot)
            
        }
    }
    func parseHeroesSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { (change) in
            
            var parsedHero: Superhero?
            
            do {
                parsedHero = try change.document
                    .data(as: Superhero.self)
            } catch {
                print("Unable to decode hero. Is the hero malformed?")
                return
            }
            
            guard let hero = parsedHero else {
                print("Document doesn't exist")
                return;
            }
            
            if change.type == .added {
                heroList.insert(hero, at: Int(change.newIndex)) }
            
            else if change.type == .modified {
                heroList[Int(change.oldIndex)] = hero            }
            
            else if change.type == .removed {
                heroList.remove(at: Int(change.oldIndex))   }
            
            listeners.invoke { (listener) in
                if listener.listenerType == ListenerType.heroes || listener.listenerType == ListenerType.all {
                    listener.onAllHeroesChange(change: .update, heroes: heroList)
                }
            }
            
            
        }
    }
    func parseTeamSnapshot(snapshot: QueryDocumentSnapshot) {
        
        defaultTeam = Team()
        defaultTeam.name = snapshot.data()["name"] as? String
        defaultTeam.id = snapshot.documentID
        
        if let heroReferences = snapshot.data()["heroes"] as? [DocumentReference] {
            // if hero references exist, loop through each and use get herobyid and add to team
            for reference in heroReferences {
                if let hero = getHeroByID(reference.documentID) {
                    defaultTeam.heroes.append(hero)
                }
            }
            
        }
        
        
        // once team has been created and added update listeners 
        listeners.invoke { (listener) in
            
            if listener.listenerType == ListenerType.team || listener.listenerType == ListenerType.all {
                listener.onTeamChange(change: .update, teamHeroes: defaultTeam.heroes)
            }
            
        }
        
    }
    
    
    
    
    
}
