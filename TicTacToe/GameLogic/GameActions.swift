//
//  GameActions.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 21/05/24.
//

import Foundation

extension GameLogic {
    
    /// Everytime the button on the grid is pressed, we give an image to it
    /// - Parameter index: the index is the pressed spot on the grid
    func buttonTap(index: Int) {
        
        //supposing the game is still ongoing
        guard grid[index] == nil && winner == nil else {
            return
        }
        
        //occupy that grid portion to the active player
        grid[index] = activePlayer
        
        //do some stuff
        gameActions(index: index)
        
        //if someone won, prompt the game over
        if checkWinner() {
            winner = activePlayer
            isGameOver = true
        } else {
            activePlayer = (activePlayer == .X) ? .O : .X
        }
    }
    
    //which player touched that grid spot? Give me their name
    func buttonLabel(index: Int) -> String {
        if let player = grid[index] {
            return player == .X ? "X" : "O"
        }
        return ""
        
    }
    
    /// The game action function describes the logic of counting and modifying the difficulty (future implementation) of the game
    /// - Parameter index: it takes an index that remembers the position on the grid
    func gameActions(index: Int) {
        if activePlayer == .X {
            moveCountX += 1
            playerHistory[.X]?.append(index)
        } else {
            moveCountO += 1
            playerHistory[.O]?.append(index)
        }
        
        //after understanding who hit their fourth move
        let currentPlayerMoveCount = activePlayer == .X ? moveCountX : moveCountO
        
        //we remove the first move of that player
        if currentPlayerMoveCount == 4 {
            removeFirstMove(of: activePlayer)
        }
        
        //we save the values for possible actions such as future implementations
        totalMoves = moveCountX + moveCountO
        
        //MARK: future implementation for difficulty
        if totalMoves > 14 {
            rotate = true
        }
    }
    
    func updateGameState(matchData: Data) {
        do {
            // Decode the match data into a suitable data structure
            let gameState = try JSONDecoder().decode(GameState.self, from: matchData)
            
            // Update game state properties based on the decoded data
            grid = gameState.grid
            activePlayer = gameState.activePlayer
            winner = gameState.winner
            isGameOver = gameState.isGameOver
            moveCountX = gameState.moveCountX
            moveCountO = gameState.moveCountO
            totalMoves = gameState.totalMoves
            playerHistory = gameState.playerHistory
            degrees = gameState.degrees
            offsetPosition = gameState.offsetPosition
        } catch {
            // Handle decoding errors
            print("Error decoding match data: \(error)")
        }
    }
    
    // Method to handle player making a move
    func makeMove(index: Int) {
        guard grid[index] == nil && winner == nil else {
            return
        }
        grid[index] = activePlayer
        gameActions(index: index)
        if checkWinner() {
            winner = activePlayer
            isGameOver = true
        } else {
            activePlayer = (activePlayer == .X ? .O : .X)
        }
        
        // TODO: Send updated game state to MatchManager
    }
    
    /// put everything back in place
    func resetGame() {
        grid = Array(repeating: nil, count: 9)
        activePlayer = .X
        winner = nil
        moveCountX = 0
        moveCountO = 0
        totalMoves = 0
        playerHistory[.X] = []
        playerHistory[.O] = []
        isGameOver = false
        degrees = 0.0
        offsetPosition = CGSize.zero
    }
    
}
