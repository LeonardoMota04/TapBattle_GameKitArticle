//
//  MenuView.swift
//  GameKitArticle
//
//  Created by Leonardo Mota on 16/08/24.
//

import SwiftUI

struct MenuView: View {
    @ObservedObject var matchManager: MatchManager

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                
                // RED SIDE
                VStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.red)
                        .frame(height: UIScreen.main.bounds.height / 2)
                    Spacer()
                }
                
                // BLUE SIDE
                VStack { 
                    Spacer()
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.blue)
                        .frame(height: UIScreen.main.bounds.height / 2)
                }
                
                // BG
                Color.black.opacity(0.5)
                
                // TITLE WITH HAND TAP
                VStack {
                    Spacer()
                    
                    VStack(spacing: 10) {
                        Text("Tap\nBattle")
                            .multilineTextAlignment(.center)
                            .font(.largeTitle)

                        Image(systemName: "hand.tap.fill")
                            .font(.system(size: 60))
                    }
                    Spacer()
                }
                .bold()
                .foregroundStyle(.white)
                
                // MARK: - INVITE A FRIEND WITH GAMEKIT
                Button("Invite a friend") {
                    matchManager.sendInvite()
                }
                .bold()
                .font(.title2)
                .foregroundColor(.white)
                .padding()
                .background(RoundedRectangle(cornerRadius: 25).fill(Color.black.opacity(0.4)))
                .position(x: geometry.size.width / 2, y: geometry.size.height / 1.5)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    MenuView(matchManager: MatchManager())
}

