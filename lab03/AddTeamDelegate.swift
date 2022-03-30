//
//  AddTeamDelegate.swift
//  lab03
//
//  Created by Saauren Mankad on 30/3/2022.
//

import Foundation
protocol AddTeamDelegate: AnyObject {
    
    func addTeam(_ newTeam: String) -> Bool
}
