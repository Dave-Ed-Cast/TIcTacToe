//
//  GameLogic.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 17/05/24.
//

import Foundation

enum Player: Codable {
    case X
    case O
}

class GameLogic: ObservableObject {
    
    @Published var grid: [Player?] = Array(repeating: nil, count: 9)
    @Published var activePlayer: Player = .X
    @Published var winner: Player? = nil
    @Published var isGameOver: Bool? = nil
    
    var playerHistory: [Player: [Int]] = [.X: [], .O: []]
    var moveCountX: Int = 0
    var moveCountO: Int = 0
    var totalMoves: Int = 0
    var winningIndices: [Int]? = nil
    var rotate: Bool = false
    var degrees: Double = 0.0
    var offsetPosition: CGSize = CGSize.zero
    
    //set winning indices
    func setWinningIndices(indices: [Int]) {
        self.winningIndices = indices
    }
    
    struct GameState: Codable{
        var grid: [Player?]
        var activePlayer: Player
        var winner: Player?
        var isGameOver: Bool
        var playerHistory: [Player: [Int]]
        var moveCountX: Int
        var moveCountO: Int
        var totalMoves: Int
        var winningIndices: [Int]?
        var rotate: Bool
        var degrees: Double
        var offsetPosition: CGSize
    }
}
