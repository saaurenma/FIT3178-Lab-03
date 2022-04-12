//
//  Superhero.swift
//  lab03
//
//  Created by Saauren Mankad on 12/4/2022.
//

import UIKit
import FirebaseFirestoreSwift

enum Universe: Int {
    case marvel = 0
    case dc = 1
}

class Superhero: NSObject, Codable {
    
    @DocumentID var id: String?
    var name: String?
    var abilities: String?
    var universe: Int?
    
    
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case name
        case abilities
        case universe
        
    }
    
    

        
    }


extension Superhero {
    
    var herouniverse: Universe {
        
        get {
            return Universe(rawValue: self.universe!)!
        }
        
        set {
            self.universe = newValue.rawValue
        }
        
        
    }
    
}



