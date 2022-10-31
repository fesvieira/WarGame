//
//  Character.swift
//  DNDGame
//
//  Created by Felipe Vieira on 31/10/22.
//

import Foundation

struct DNDCharacter: Hashable {
    var name: String
    var role: String
    var life: Int
    var defense: Int
    
    init(name: String, role: String, life: Int, defense: Int) {
        self.name = name
        self.role = role
        self.life = life
        self.defense = defense
    }
}
