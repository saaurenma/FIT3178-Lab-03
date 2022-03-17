//
//  Superhero.swift
//  lab03
//
//  Created by Saauren Mankad on 17/3/2022.
//

import UIKit


enum Universe: Int {
    
    case marvel = 0
    case dc = 1
    
}

class Superhero: NSObject {
    var name: String?
    var abilities: String?
    var universe: Universe?
    
    init(newName:String, newAbilities:String, newUniverse:Universe){
        
        name = newName
        abilities = newAbilities
        universe = newUniverse
        
    }
    
}
