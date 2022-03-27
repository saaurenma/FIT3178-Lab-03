//
//  DatabaseProtocol.swift
//  lab03
//
//  Created by Saauren Mankad on 28/3/2022.
//

import Foundation

enum DatabaseChange {
    
    case add
    case remove
    case update
    
}


enum ListenerType {
    
    case team
    case heroes
    case all
    
}

protocol DatabaseListener: AnyObject {
    
    var listenerType: ListenerType{get set}
    func onTeamChange(change: DatabaseChange, teamHeroes: [Superhero])
    func onAllHeroesChange(change: DatabaseChange, heroes: [Superhero])
    
}

protocol DatabaseProtocol: AnyObject {
    func cleanup()
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    func addSuperhero(name: String, abilities: String, universe: Universe) -> Superhero
    func deleteSuperhero(hero: Superhero)
    
}
