//
//  GameMessage.swift
//  Mini06Game
//
//  Created by Leonardo Mota on 26/07/24.
//

import Foundation

// GENERAL game message
/// ALL that is going to be shared
enum GameMessage: Codable {
    // game controls
    case goToGame
    case startGame
    case endGame(Player.PlayerRole?)
    case resetGame
    
    // role selection
    case playerRole(Player.PlayerRole?)
    
    // timer
    case timer(Int)
    
    // tap on the screen
    case tap
    
    // encode and decode the message into / from Data
    func encode() -> Data? {
        try? JSONEncoder().encode(self)
    }
    
    static func decode(from data: Data) -> GameMessage? {
        try? JSONDecoder().decode(GameMessage.self, from: data)
    }
}

