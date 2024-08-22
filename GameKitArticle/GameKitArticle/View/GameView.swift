//
//  GameView.swift
//  GameKitArticle
//
//  Created by Leonardo Mota on 16/08/24.
//

import SwiftUI


struct GameView: View {
    
    // MARK: - VARIABLES
    @ObservedObject var matchManager: MatchManager
    @State private var winnerMessage: String?
    
    // Configs
    private let timerOptions = [10, 20, 30]
    
    // MARK: - VIEW
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // BG
                Color.black.ignoresSafeArea()
                
                // OPPONENT RECTANGLE
                rectangleView(
                    color: matchManager.otherPlayerSelection?.role == .playerBLUE ? .blue : .red,
                    height: matchManager.otherPlayerRectangleSize,
                    isLocal: false,
                    text: matchManager.otherPlayerSelection?.displayName ?? "",
                    geometry: geometry
                )
                
                // LOCAL RECTANGLE
                rectangleView(
                    color: matchManager.playerSelection?.role == .playerBLUE ? .blue : .red,
                    height: matchManager.localPlayerRectangleSize,
                    isLocal: true,
                    text: "You: (\(matchManager.playerSelection?.displayName ?? ""))",
                    geometry: geometry
                )
                
                // BG
                if matchManager.gameState != .inGame { Color.black.opacity(0.5) }
                
                // HUD View
                hudView(geometry: geometry)
            }
            
            // LOCAL TAP
            .onTapGesture {
                handleLocalTap(geometry: geometry)
            }
            
            // ON CHANGE OF GAME STATE
            .onChange(of: matchManager.gameState) { oldValue, newValue in
                switch newValue {
                case .gameWin:
                    winnerMessage = "You won!"
                    
                case .gameOver:
                    winnerMessage = "You lost!\n\(matchManager.otherPlayerSelection!.displayName) won!"
                
                case .gameTie:
                    winnerMessage = "It's a tie!\nYou both look terrible..."
                    
                default:
                    break
                } 
            }
        }
        .ignoresSafeArea()
    }
    
    /// Creates a HUD View with a config button, timer, start and end game views
    @ViewBuilder
    private func hudView(geometry: GeometryProxy) -> some View {
        ZStack {
            // CONFIG BUTTON
            if matchManager.playerSelection?.isHost == true {
                Menu {
                    // TIMER PICKER
                    // MARK: - CHANGE TIMER
                    Picker(selection: $matchManager.remainingTime, label: Text("Timer")) {
                        ForEach(timerOptions, id: \.self) { option in
                            Text("\(option)s").tag(option)
                        }
                    }
                } label: {
                    Image(systemName: "gear")
                        .padding()
                        .background(Circle().fill(Color.black.opacity(0.4)))

                }
                .highPriorityGesture(TapGesture())
                .position(x: geometry.size.width - 50, y: 90)
                .bold()
                .font(.title2)
                .foregroundColor(.white)
            }
            
            // TIMER
            Label("\(matchManager.remainingTime)", systemImage: "clock.fill")
                .bold()
                .font(.title)
                .foregroundColor(.white)
                .monospacedDigit()
                .padding()
                .background(RoundedRectangle(cornerRadius: 25).fill(Color.black.opacity(0.4)))
                .position(x: geometry.size.width / 2, y: 90)
            
            // START BUTTON
            if matchManager.gameState == .gameReady {
                if matchManager.playerSelection?.isHost == true {
                    // MARK: - START GAME
                    Button("Start") {
                        matchManager.startGame()
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 25).fill(Color.black.opacity(0.4)))
                    .foregroundStyle(.white)
                    .bold()
                    .position(x: geometry.size.width / 2, y: geometry.size.height - 50)
                }
            }
            
            // END GAME VIEW (winning and losing messsage and reset button)
            if matchManager.gameState == .gameOver || matchManager.gameState == .gameWin || matchManager.gameState == .gameTie {
                VStack {
                    Spacer()
                    Text(winnerMessage ?? "")
                        .multilineTextAlignment(.center)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    
                    Spacer()
                    // MARK: - RESET GAME
                    if matchManager.playerSelection?.isHost == true {
                        Button("Reset game") {
                            matchManager.resetGame()
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 25).fill(Color.black.opacity(0.4)))
                        .padding(.bottom, 50)
                    }
                }
                .foregroundStyle(.white)
                .bold()
            }
        }
    }
    
    /// Creates the rectangle from each player, based on the necessary data
    @ViewBuilder
    private func rectangleView(color: Color, height: CGFloat, isLocal: Bool, text: String, geometry: GeometryProxy) -> some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(color)
            .frame(width: geometry.size.width, height: max(0, min(height, geometry.size.height)))
            .position(x: geometry.size.width / 2, y: isLocal
                      ? geometry.size.height - height / 2
                      : height / 2)
        
        Text(text)
            .position(x: geometry.size.width / 2,
                      y: isLocal
                      ? (geometry.size.height - height) + 20
                      : height - 20)
            .font(.footnote)
            .foregroundStyle(.white)
            .bold()
    }
    
    // MARK: - FUNCTION
    /// Local tap
    private func handleLocalTap(geometry: GeometryProxy) {
        withAnimation {
            if matchManager.localPlayerRectangleSize >= geometry.size.height {
                matchManager.localPlayerRectangleSize = geometry.size.height
            } else {
                // MARK: - SEND CLICK
                matchManager.sendTap()
            }
        }
    }
}

#Preview {
    GameView(matchManager: MatchManager())
}




