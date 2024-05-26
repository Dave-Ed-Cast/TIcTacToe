//
//  GameView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/05/24.
//

import SwiftUI

var countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

struct GameView: View {
    
    @ObservedObject var matchManager: MatchManager
    @ObservedObject var gameLogic: GameLogic
    
    @Binding var isOffline: Bool
    
    var body: some View {
        
        Group {
            VStack {
                
                Text("Tria Tactics")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .padding()
                Text("Time left: \(matchManager.remainingTime)")
                    .font(.title)
                    .fontWeight(.semibold)
                HStack {
                    
                    Text("Current turn: ")
                        .font(.title)
                        .fontWeight(.semibold)
                    Text(matchManager.isLocalPlayerTurn ? "Your Turn" : "Opponent's Turn")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(matchManager.isLocalPlayerTurn ? .green : .red)
                }
                .padding()
                .padding(.bottom, 50)
            }
            .foregroundStyle(.black)
            
            GameGrid(matchManager: matchManager, gameLogic: gameLogic)
                .padding()
            
            Button {
                if gameLogic.checkWinner() {
                    gameLogic.resetGame()
                }
            } label: {
                Text(isOffline ? "Restart" : "Finish")
                    .frame(width: 200, height: 70, alignment: .center)
                    .background(.yellow)
                    .foregroundStyle(.black)
                    .font(.title3)
                    .fontWeight(.medium)
                    .cornerRadius(20)
            }
            .onSubmit {
                matchManager.isGameOver = true
            }
            .opacity(gameLogic.checkWinner() ? 1 : 0.5)
            .disabled(!gameLogic.checkWinner())
            .padding()
            
        }
        .onAppear {
            gameLogic.resetGame()
        }
        .onReceive(countdownTimer) { _ in
            guard matchManager.isTimeKeeper else { return }
            matchManager.remainingTime -= 1
        }
    }
}


#Preview {
    GameView(matchManager: MatchManager(), gameLogic: GameLogic(), isOffline: .constant(true))
}
