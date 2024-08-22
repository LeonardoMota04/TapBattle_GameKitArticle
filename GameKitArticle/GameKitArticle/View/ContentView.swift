//
//  ContentView.swift
//  GameKitArticle
//
//  Created by Leonardo Mota on 16/08/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var matchManager: MatchManager = MatchManager()
    
    var body: some View {
        ZStack {
            // Determine the current view based on gameState
            switch matchManager.gameState {
            case .none:
                MenuView(matchManager: matchManager)
            case .inPreGame:
                RoleSelectionView(matchManager: matchManager)
                    .transition(.move(edge: .trailing))
            default:
                GameView(matchManager: matchManager)
                    .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut, value: matchManager.gameState)
        
        // MARK: - AUTHENTICATE THE USER WITH GAME CENTER
        .onAppear {
            matchManager.authenticateUser()
        }
    }
}

#Preview {
    ContentView()
}

