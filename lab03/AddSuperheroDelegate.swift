//
//  AddSuperheroDelegate.swift
//  lab03
//
//  Created by Saauren Mankad on 17/3/2022.
//

import Foundation

protocol AddSuperHeroDelegate: AnyObject {
    func addSuperhero(_ newHero: Superhero) -> Bool
}
