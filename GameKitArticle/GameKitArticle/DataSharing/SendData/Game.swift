//
//  SendData_Extension.swift
//  Mini06Game
//
//  Created by Leonardo Mota on 25/07/24.
//

import Foundation
import GameKit
import SwiftUI

// MARK: - DATA SENDING
/*
 Pattern:
    - Check if 'match' exists
    - Create message
    - Send message
    - Update the local state
 */
extension MatchManager {
    
    // MARK: - ROLE SELECTION
    func selectRole(role: Player.PlayerRole?) {
        guard match != nil else { return }

        // Send a message with the selected role
        if playerSelection != nil {
            let message = GameMessage.playerRole(role)
            sendGameMessage(message)
        }
        
        // Update the local player's role
        playerSelection?.role = role
    }
    
    // MARK: - GAME START
    // Go to the GameView
    func goToGame() {
        guard match != nil else { return }
        
        // Send a message to transition to the game view
        sendGameMessage(.goToGame)
        
        // Update the local game state
        gameState = .gameReady
    }
    
    // Start the game
    func startGame() {
        guard match != nil else { return }
        
        // Send the start game message
        sendGameMessage(.startGame)
        
        // Update the local game state
        gameState = .inGame
        startTimer()
    }
    
    // MARK: - TAP ON THE SCREEN
    // Send a tap action message
    func sendTap() {
        guard match != nil else { return }
        guard gameState == .inGame else { return }
        
        // Send the click message
        sendGameMessage(.tap)
        
        // Update the local state
        withAnimation {
            self.localPlayerRectangleSize += UIScreen.main.bounds.height * 0.025
            self.otherPlayerRectangleSize -= UIScreen.main.bounds.height * 0.025
        }
    }
    
    // MARK: - GAME END
    // Ends the game with a winner or not (tie)
    func endGame(winner: Player.PlayerRole?) {
        guard match != nil else { return }
        stopTimer()

        // Send the message to the other player to end the game
        sendGameMessage(.endGame(winner))
        
        // local game state
        if let winner = winner {
            if winner == playerSelection?.role {
                gameState = .gameWin
            } else {
                gameState = .gameOver
            }
        } else {
            gameState = .gameTie
        }
        
    }
    
    // MARK: - GAME RESET
    // RESET THE GAME
    func resetGame() {
        guard match != nil else { return }
        
        // Send the reset game message
        sendGameMessage(.resetGame)

        // Update the local game state
        gameState = .gameReady
        localPlayerRectangleSize = UIScreen.main.bounds.height / 2
        otherPlayerRectangleSize = UIScreen.main.bounds.height / 2
        remainingTime = 20
    }

    /// Reusable functions
    // Send a game message
    func sendGameMessage(_ message: GameMessage) {
        guard let data = message.encode() else { return }
        sendData(data, mode: .reliable)
    }
    
    // Generic function to send data
    func sendData(_ data: Data, mode: GKMatch.SendDataMode) {
        do {
            try match?.sendData(toAllPlayers: data, with: mode)
        } catch {
            print(error)
        }
    }
}



