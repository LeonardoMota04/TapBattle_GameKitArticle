//
//  Timer.swift
//  GameKitArticle
//
//  Created by Leonardo Mota on 20/08/24.
//

import Foundation

// TIMER
/// Controlled by the host
extension MatchManager {
    // Starts the timer
    func startTimer() {
        guard playerSelection?.isHost == true else { return }
        
        countdownTimer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.remainingTime -= 1
            }
    }
    
    // Stops the timer
    func stopTimer() {
        guard playerSelection?.isHost == true else { return }
        
        countdownTimer?.cancel()
    }
}
