//
//  ContentView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 17/05/24.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var gameLogic: GameLogic = GameLogic()
    var body: some View {
        
        VStack {
            
            Text("Tic Tac Toe")
                .font(.largeTitle)
                .fontWeight(.black)
            Text("Revisited")
                .font(.callout)
            
            GameGrid()
                .padding()
            
            Button {
                gameLogic.resetGame()
            } label: {
                Text("Restart")
                    .frame(width: 200, height: 70, alignment: .center)
                    .background(.black)
                    .foregroundStyle(.white)
                    .font(.title3)
                    .fontWeight(.medium)
                    .cornerRadius(20)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
