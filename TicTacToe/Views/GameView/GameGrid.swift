//
//  Grid.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/05/24.
//

import SwiftUI

struct GameGrid: View {
    
    
    @ObservedObject var gameLogic: GameLogic
    @ObservedObject var matchManager: MatchManager
    
    let col = Array(repeating: GridItem(.flexible()), count: 3)
    
    @State private var showLottieAnimation = false
    @State private var index: Int = 0
    
    var body: some View {
        ZStack {
            BackgroundGridViewModel()
            
            VStack(spacing: 35) {
                ForEach(0..<3) { row in
                    HStack(spacing: 40) {
                        ForEach(0..<3) { col in
                            let index = row * 3 + col
                            Button {
                                gameLogic.buttonTap(index: index)
                                matchManager.sendMoveToMatchManager(index: index)
                            } label: {
                                Image(gameLogic.buttonLabel(index: index))
                                    .interpolation(.none)
                                    .resizable()
                                    .frame(width: 80, height: 80)
                            }
                        }
                    }
                }
            }
            .onAppear{

            }
            
            if gameLogic.isGameOver ?? false {
                ZStack {
                    LottieAnimation(
                        name: "Line",
                        contentMode: .scaleAspectFit,
                        playbackMode: .playing(.fromFrame(1, toFrame: 26, loopMode: .playOnce)),
                        scaleFactor: 8,
                        degrees: gameLogic.degrees,
                        offset: gameLogic.offsetPosition)
                    
                    if showLottieAnimation {
                        LottieAnimation(
                            name: "GameOver",
                            contentMode: .center,
                            playbackMode: .playing(.toProgress(1, loopMode: .playOnce)),
                            scaleFactor: 0.9)
                        .background(Color.black.opacity(0.75))
                        .cornerRadius(20)
                        .padding()
                    }
                }
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { _ in
                        withAnimation {
                            showLottieAnimation = true
                        }
                    }
                    showLottieAnimation = false
                }
                .onDisappear {
                    
                }
            }
        }
    }
}

#Preview {
    GameGrid(gameLogic: GameLogic(), matchManager: MatchManager(gameLogic: GameLogic()))
}
