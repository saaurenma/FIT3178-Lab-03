//
//  CoreDataController.swift
//  lab03
//
//  Created by Saauren Mankad on 28/3/2022.
//

import UIKit

import CoreData

class CoreDataController: NSObject {
    
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer: NSPersistentContainer
    
    override init() {
        
        persistentContainer = NSPersistentContainer(name: "Week04-DataModel")
        persistentContainer.loadPersistentStores() {(description, error) in if let error = error {
            fatalError("Falied to load Core Data Stack with error: \(error)")
            }
            
        }
        super.init()
        
        if fetchAllHeroes().count == 0 {
            createDefaultHeroes()
        }
    }
    
    
    func cleanup() {
        
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save changes to Core Data with error: \(error)")
            }
        }
        
    }
    
    func addSuperhero(name: String, abilities: String, universe: Universe) -> Superhero {
        
        
        let hero = NSEntityDescription.insertNewObject(forEntityName: "Superhero", into: persistentContainer.viewContext) as! Superhero
        
        hero.name = name
        hero.abilities = abilities
        hero.heroUniverse = universe
        
        return hero
    }
    
    
    func deleteSuperhero(hero: Superhero) {
        persistentContainer.viewContext.delete(hero)
        
    }
    
    func fetchAllHeroes() -> [Superhero] {
        
        var heroes = [Superhero]()
        
        let request: NSFetchRequest<Superhero> = Superhero.fetchRequest()
        
        do {
            try heroes = persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch Request failed with error: \(error)")
        }
        return heroes
    }
    
    
    func addListener(listener: DatabaseListener) {
        
        listeners.addDelegate(listener)
        
        if listener.listenerType == .heroes || listener.listenerType == .all {
            listener.onAllHeroesChange(change: .update, heroes: fetchAllHeroes())
        }
        
    }
    

    func removeListener(listener: DatabaseListener) {
        
        listeners.removeDelegate(listener)
        
    }
    
    func createDefaultHeroes() {
        
        let _ = addSuperhero(name: "Bruce Wayne", abilities: "Money", universe: .dc)
        
        let _ = addSuperhero(name: "Superman", abilities: "Super Powered Alien", universe: .dc)
        
        let _ = addSuperhero(name: "Wonder Woman", abilities: "Goddess", universe: .dc)
        
        let _ = addSuperhero(name: "The Flash", abilities: "Speed", universe: .dc)
        
        let _ = addSuperhero(name: "Green Lantern", abilities: "Power Ring", universe: .dc)
        let _ = addSuperhero(name: "Cyborg", abilities: "Robot Beep Beep", universe: .dc)
        let _ = addSuperhero(name: "Aquaman", abilities: "Atlantian", universe: .dc)
        let _ = addSuperhero(name: "Captain Marvel", abilities: "Superhuman Strength", universe: .marvel)
        
        let _ = addSuperhero(name: "Spider-Man", abilities: "Spider Sense", universe: .marvel)
    }
    
}
