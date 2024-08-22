//
//  RoleSelectionView.swift
//  GameKitArticle
//
//  Created by Leonardo Mota on 16/08/24.
//

import SwiftUI

struct RoleSelectionView: View {
    @ObservedObject var matchManager: MatchManager

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // BG
                Color.black.ignoresSafeArea()
                
                // Buttons for selecting roles
                HStack {
                    // MARK: - BLUE BUTTON
                    Button(action: {
                        matchManager.selectRole(role: .playerBLUE)
                    }) {
                        VStack {
                            Spacer()
                            Text("BLUE")
                                .font(.largeTitle)
                                .bold()
                            Spacer()
                        }
                        .frame(width: geometry.size.width / 3, height: geometry.size.height / 3)
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .overlay(alignment: .bottom) {
                        Text( // Overlay for the player's name
                            matchManager.otherPlayerSelection?.role == .playerBLUE
                            ? matchManager.otherPlayer!.displayName
                            : matchManager.playerSelection?.role == .playerBLUE
                            ? matchManager.localPlayer.displayName
                            : ""
                        )
                        .padding(.bottom)
                        .foregroundColor(.white)
                        .font(.callout)
                        .bold()
                    }
                    
                    // MARK: - RED BUTTON
                    Button(action: {
                        matchManager.selectRole(role: .playerRED)
                    }) {
                        VStack {
                            Spacer()
                            Text("RED")
                                .font(.largeTitle)
                                .bold()
                            Spacer()
                        }
                        .frame(width: geometry.size.width / 3, height: geometry.size.height / 3)
                        .background(Color.red)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .overlay(alignment: .bottom) {
                        Text( // Overlay for the player's name
                            matchManager.otherPlayerSelection?.role == .playerRED
                            ? matchManager.otherPlayer!.displayName
                            : matchManager.playerSelection?.role == .playerRED
                            ? matchManager.localPlayer.displayName
                            : ""
                        )
                        .padding(.bottom)
                        .foregroundColor(.white)
                        .font(.callout)
                        .bold()
                    } 
                }
                
                // Title and Start button
                VStack {
                    Text("Choose your color")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 25).fill(Color.black.opacity(0.4)))
                        .padding(.top, 30)
                    
                    Spacer()
                    
                    if let playerSelection = matchManager.playerSelection, playerSelection.isHost {
                        // MARK: - GO TO GAME VIEW
                        Button("Start") {
                            matchManager.goToGame()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color.white)
                        .foregroundStyle(.black)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    RoleSelectionView(matchManager: MatchManager())
}
