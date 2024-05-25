//
//  OnlineView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 24/05/24.
//

import SwiftUI

struct OnlineView: View {
    
    @ObservedObject var matchManager: MatchManager
    @ObservedObject var gameLogic : GameLogic
    @Binding var currentStep: Int
    @Binding var skipOnboarding: Bool
    
    var body: some View {
        ZStack {
            VStack {
                if matchManager.autheticationState == .authenticated {
                    if matchManager.inGame {
                        // If in a game, show the GameView
                        GameView(gameLogic: gameLogic)
                    } else {
                        // If not in a game, show the appropriate message
                        if matchManager.isGameOver {
                            Text("Press restart to play again!")
                        } else if matchManager.match != nil {
                            // If a match is found, show invite button
                            Button("Invite Friend to Play") {
                                matchManager.startMatchmaking()
                            }
                        } else {
                            Text("Searching for opponents...")
                        }
                    }
                } else {
                    // If not authenticated, show authentication message
                    Text("You are not logged in Game Center!")
                }
            }
        }
        .onAppear {
            matchManager.startMatchmaking()
        }
        .onReceive(matchManager.$inGame) { inGame in
            // When inGame state changes, update the gameLogic accordingly
            if inGame {
                // Game started, initialize GameLogic
                gameLogic.resetGame()
            } else {
                // Game ended, clean up GameLogic
                gameLogic.isGameOver = true
            }
        }
    }
}

#Preview {
    OnlineView(matchManager: MatchManager(gameLogic: GameLogic()), gameLogic: GameLogic(), currentStep: .constant(0), skipOnboarding: .constant(false))
}
