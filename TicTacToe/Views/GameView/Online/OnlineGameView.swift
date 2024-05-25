//
//  OnlineGameView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 25/05/24.
//

import SwiftUI

struct OnlineGameView: View {
    
    @ObservedObject var gameLogic: GameLogic
    @ObservedObject var matchManager: MatchManager
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        Group {
            VStack {
                Text("Tria Tactics")
                    .font(.largeTitle)
                    .fontWeight(.black)
                HStack {
                    Text("Turn of: ")
                        .font(.title)
                        .fontWeight(.semibold)
                    Text("\(gameLogic.activePlayer == .X ? "X" : "O")")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                
                .padding()
                .padding(.bottom, 50)
            }
            .foregroundStyle(.black)
            
            GameGrid(gameLogic: gameLogic, matchManager: matchManager)
                .padding()
            
            Button {
                if gameLogic.checkWinner() {
                    gameLogic.resetGame()
                }
            } label: {
                Text("Restart")
                    .frame(width: 200, height: 70, alignment: .center)
                    .background(.yellow)
                    .foregroundStyle(.black)
                    .font(.title3)
                    .fontWeight(.medium)
                    .cornerRadius(20)
                    .opacity(gameLogic.checkWinner() ? 1 : 0.5)
            }
            .disabled(!gameLogic.checkWinner())
            .padding()
            
        }
        .onAppear {
            gameLogic.resetGame()
        }
        
    }
}

#Preview {
    OnlineGameView(gameLogic: GameLogic(), matchManager: MatchManager(gameLogic: GameLogic()))
}
