//
//  DatabaseProtocol.swift
//  lab03
//
//  Created by Saauren Mankad on 28/3/2022.
//

import Foundation
import Firebase

enum DatabaseChange {
    
    case add
    case remove
    case update
    
}


enum ListenerType {
    
    case team
    case heroes
    case all
    case auth
    
}

protocol DatabaseListener: AnyObject {
    
    var listenerType: ListenerType{get set}
    func onTeamChange(change: DatabaseChange, teamHeroes: [Superhero])
    func onAllHeroesChange(change: DatabaseChange, heroes: [Superhero])
    func onAuthChange(change: DatabaseChange, userIsLoggedIn: Bool, error:String)
    
}

protocol DatabaseProtocol: AnyObject {
    var defaultTeam: Team {get}

    
    func cleanup()
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    func addSuperhero(name: String, abilities: String, universe: Universe) -> Superhero
    func deleteSuperhero(hero: Superhero)

    // team
    func addTeam(teamName: String) -> Team
    func deleteTeam(team: Team)
    func addHeroToTeam(hero: Superhero, team: Team) -> Bool
    func removeHeroFromTeam(hero:Superhero, team:Team)
    
    func logInUser(email: String, password: String)
    func createUser(newEmail: String, newPassword: String)
    
}
