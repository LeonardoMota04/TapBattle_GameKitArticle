//
//  MatchManager.swift
//  GameKitArticle
//
//  Created by Leonardo Mota on 16/08/24.
//

// MARK: - MATCH MANAGER
import Foundation
import GameKit
import SwiftUI
import Combine

class MatchManager: NSObject, ObservableObject, GKLocalPlayerListener {
    
    // ViewController
    var rootViewController: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }

    // Player Info
    @Published var playerAuthState = PlayerAuthState.authenticating
    @Published var playerSelection: Player?
    @Published var otherPlayerSelection: Player?
    
    // Connection
    var match: GKMatch?
    var localPlayer = GKLocalPlayer.local
    var otherPlayer: GKPlayer?
    var currentInvite: GKInvite?
        
    // MARK: - GAME VARIABLES
    // Game State
    @Published var gameState = GameState.none
    
    // Countdown Timer
    var countdownTimer: Cancellable?
    @Published var remainingTime = 20 { // This is the variable that is going to be shared
        willSet {
            if playerSelection!.isHost { sendGameMessage(.timer(newValue)) } // every sec
            if newValue == 0 { endGame(winner: nil) } // when hits 0
        }
    }

    // Opponent Rectangle
    @Published var otherPlayerRectangleSize: CGFloat = UIScreen.main.bounds.height / 2
    
    // Local Rectangle
    @Published var localPlayerRectangleSize: CGFloat = UIScreen.main.bounds.height / 2 {
        willSet {
            if newValue == UIScreen.main.bounds.height { self.endGame(winner: playerSelection!.role!) }
        }
    }

    
    // MARK: - Authenticate the user in GameCenter
    func authenticateUser() {
        GKLocalPlayer.local.authenticateHandler = { [self] (gameCenterAuthViewController, error) in
            if let viewController = gameCenterAuthViewController {
                rootViewController?.present(viewController, animated: true)
                return
            }
            if let error = error {
                playerAuthState = .error
                print(error.localizedDescription)
                return
            }
            if localPlayer.isAuthenticated {
                if localPlayer.isMultiplayerGamingRestricted {
                    playerAuthState = .restricted
                } else {
                    playerAuthState = .authenticated
                    GKLocalPlayer.local.register(self)
                }
            } else {
                playerAuthState = .unauthenticated
            }
        }
    }
    
    // MARK: - INVITES
    // send a invite
    func sendInvite() {
        let request = GKMatchRequest()
        request.maxPlayers = 2
        request.minPlayers = 2

        if let matchmakerVC = GKMatchmakerViewController(matchRequest: request) {
            matchmakerVC.matchmakerDelegate = self
            matchmakerVC.matchmakingMode = .inviteOnly
            rootViewController?.present(matchmakerVC, animated: true)
        }
    }
    
    // MatchMaking - only the invited player has access to the invitation
    func startMatchmaking(withInvite invite: GKInvite? = nil) {
        guard localPlayer.isAuthenticated else { return }
        
        currentInvite = invite
                    
        if let invite = invite {
            if let matchmakerViewController = GKMatchmakerViewController(invite: invite) {
                matchmakerViewController.matchmakerDelegate = self
                rootViewController?.present(matchmakerViewController, animated: true)
            }
        } else {
            // If there is no invite, do not start matchmaking
            /// This should not happen.
            print("No invite available, not starting matchmaking.")
        }
    }

    
    // MARK: - START OF THE MATCH AFTER BOTH PLAYERS CONNECT
    // Start the match after both players have connected
    func setRoles_and_StartNewMatch(newMatch: GKMatch) {
        match = newMatch
        match?.delegate = self

        // Determine if the local player is the host
        if currentInvite != nil { // There is an invite because the other player invited you
            playerSelection = Player(displayName: localPlayer.displayName)
        } else { // You initiated the match, so you are the host
            playerSelection = Player(displayName: localPlayer.displayName, isHost: true)
        }

        otherPlayerSelection = Player(displayName: match!.players.first!.displayName)
        otherPlayer = match?.players.first

        gameState = .inPreGame
    }
}

// MARK: - EXTENSION
// MatchmakerViewController - handles finding and connecting to a match
extension MatchManager: GKMatchmakerViewControllerDelegate {
    
    // Invitation accepted
    /// The device that sends the invite does not go through this method
    func player(_ player: GKPlayer, didAccept invite: GKInvite) {
        startMatchmaking(withInvite: invite)
    }
    
    // When both players are actually connected
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        viewController.dismiss(animated: true)
        setRoles_and_StartNewMatch(newMatch: match)
    }
    
    // ViewController cancelled
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        viewController.dismiss(animated: true)
    }
    
    // Failed with error
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        viewController.dismiss(animated: true)
    }
}





