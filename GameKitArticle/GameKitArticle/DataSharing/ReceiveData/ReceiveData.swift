//
//  ReceiveData_Extension.swift
//  Mini06Game
//
//  Created by Leonardo Mota on 25/07/24.
//

import Foundation
import GameKit
import SwiftUI

// MARK: - RECEIVING DATA
extension MatchManager: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, forRecipient recipient: GKPlayer, fromRemotePlayer player: GKPlayer) {
        
        // MARK: - GENERAL GAME MESSAGE
        if let gameMessage = GameMessage.decode(from: data) {
            DispatchQueue.main.async { [self] in
                switch gameMessage {
                    // ROLE
                case .playerRole(let role):
                    otherPlayerSelection!.role = role
                    
                    // TIMER
                case .timer(let time):
                   remainingTime = time
                    
                    // GO TO GAME VIEW
                case .goToGame:
                   gameState = .gameReady
                    
                    // START OF A GAME
                case .startGame:
                   gameState = .inGame
                    
                    // END OF A GAME
                case .endGame(let winner):
                    stopTimer() 

                    if let winner = winner {
                        if winner == playerSelection?.role {
                            gameState = .gameWin
                        } else {
                            gameState = .gameOver
                        }
                    } else {
                        gameState = .gameTie
                    }

                    // RESET OF THE GAME
                case .resetGame:
                    gameState = .gameReady
                    localPlayerRectangleSize = UIScreen.main.bounds.height / 2
                    otherPlayerRectangleSize = UIScreen.main.bounds.height / 2
                    
                    // GAME TAP
                case .tap:
                    withAnimation {
                        self.localPlayerRectangleSize -= UIScreen.main.bounds.height * 0.025
                        self.otherPlayerRectangleSize += UIScreen.main.bounds.height * 0.025
                    }
                }
                
            }
        } else {
            // The received data does not match any known format
            fatalError("The received data does not match any known format") // treat the error
        }
    }
    
    // MARK: - RECEIVED CONNECTION DATA
    // Player disconnected
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        guard state == .disconnected else { return }
        let alert = UIAlertController(title: "Player Disconnected", message: "Oh no! The other player has disconnected...", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.match?.disconnect()
        })
        
        DispatchQueue.main.async {
            // reset
            self.rootViewController?.present(alert, animated: true)
        }
    }
    
    // Should reinvite
    func match(_ match: GKMatch, shouldReinviteDisconnectedPlayer player: GKPlayer) -> Bool {
        return true
    }
    
    // Failed with error
    func match(_ match: GKMatch, didFailWithError error: Error?) {
        // Handle match failure due to an error
        let alert = UIAlertController(title: "Match Error", message: "An error occurred during the match: \(error?.localizedDescription ?? "Unkwown")", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.match?.disconnect()
        })
        
        DispatchQueue.main.async {
            // Reset
            self.rootViewController?.present(alert, animated: true)
        }
    }
}
