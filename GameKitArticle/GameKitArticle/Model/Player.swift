//
//  Player.swift
//  GameKitArticle
//
//  Created by Leonardo Mota on 16/08/24.
//

import Foundation

struct Player: Identifiable, Codable {
    var id: UUID = UUID()
    var displayName: String
    var isHost: Bool = false
    var role: PlayerRole? = nil
    
    enum PlayerRole: String, Codable {
        case playerRED
        case playerBLUE
    }
}

enum PlayerAuthState {
    case authenticating
    case authenticated
    case unauthenticated
    case restricted
    case error
}
