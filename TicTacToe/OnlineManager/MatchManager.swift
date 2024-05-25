//
//  MatchManager.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 22/05/24.
//

import Foundation
import GameKit
import SwiftUI

class MatchManager: NSObject, ObservableObject, GKTurnBasedMatchmakerViewControllerDelegate, GKTurnBasedEventListener, GKLocalPlayerListener {
    
    @Published var inGame: Bool = false
    @Published var isGameOver: Bool = false
    @Published var autheticationState: PlayerAuthState = .authenticating
    @Published var currentlyPlaying: Bool = false
    @Published var score: Int = 0
    @Published var activePlayer: Player = .X
    
    var match: GKTurnBasedMatch?
    var localPlayer: GKLocalPlayer = GKLocalPlayer.local
    var playerUUIDString = UUID().uuidString
    var rootViewController: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }
    var gameLogic: GameLogic // Add this property
    
    // Existing properties and methods
    
    init(gameLogic: GameLogic) { // Add this initializer
        self.gameLogic = gameLogic
        super.init()
        GKLocalPlayer.local.register(self)
    }
    
    func authenticateUser() {
        GKLocalPlayer.local.authenticateHandler = { [weak self] viewController, error in
            if let viewController = viewController {
                self?.rootViewController?.present(viewController, animated: true)
                return
            }
            
            if let error = error {
                self?.autheticationState = .error
                print(error)
                return
            }
            
            if let localPlayer = self?.localPlayer, localPlayer.isAuthenticated {
                if localPlayer.isMultiplayerGamingRestricted {
                    self?.autheticationState = .restricted
                } else {
                    self?.autheticationState = .authenticated
                }
            } else {
                self?.autheticationState = .unauthenticated
            }
        }
    }
    
    func startMatchmaking() {
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        
        let matchMakerViewController = GKTurnBasedMatchmakerViewController(matchRequest: request)
        matchMakerViewController.turnBasedMatchmakerDelegate = self
        rootViewController?.present(matchMakerViewController, animated: true, completion: nil)
    }
    
    func startGame(match: GKTurnBasedMatch) {
        self.match = match
        // Initialize your game state with the match data
        self.inGame = true
        GKLocalPlayer.local.register(self)
    }
    
    // MARK: - GKTurnBasedMatchmakerViewControllerDelegate
    func turnBasedMatchmakerViewController(_ viewController: GKTurnBasedMatchmakerViewController, didFind match: GKTurnBasedMatch) {
        viewController.dismiss(animated: true, completion: nil)
        startGame(match: match)
    }
    
    func turnBasedMatchmakerViewControllerWasCancelled(_ viewController: GKTurnBasedMatchmakerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func turnBasedMatchmakerViewController(_ viewController: GKTurnBasedMatchmakerViewController, didFailWithError error: Error) {
        print("Matchmaking failed with error: \(error.localizedDescription)")
        viewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - GKTurnBasedEventListener
    func player(_ player: GKPlayer, receivedTurnEventFor match: GKTurnBasedMatch, didBecomeActive: Bool) {
        // Handle turn events
        if didBecomeActive {
            // It's the player's turn, handle the turn event
            if match.currentParticipant?.player?.gamePlayerID == localPlayer.gamePlayerID {
                // It's the local player's turn, call makeMove method in GameLogic
                if let data = match.matchData {
                    gameLogic.updateGameState(matchData: data)
                }
            }
        }
    }
    
    func player(_ player: GKPlayer, matchEnded match: GKTurnBasedMatch) {
        // Handle end of match
        // Example: Show game over screen
        self.isGameOver = true
    }
    
    // MARK: - GKLocalPlayerListener
    func player(_ player: GKPlayer, didAccept inviteTo: GKInvite) {
        // Handle invitation acceptance
    }
    
    // MARK: - GameLogic Communication
    func sendMoveToMatchManager(index: Int) {
        // Convert game state to match data and send to MatchManager
        if let match = self.match {
            // Convert game state to Data
            let gameData = try? JSONEncoder().encode(gameLogic.grid)
            
            // Check if conversion was successful
            guard let data = gameData else {
                print("Failed to encode game data")
                return
            }
            
            match.endTurn(withNextParticipants: [match.currentParticipant!],
                          turnTimeout: GKExchangeTimeoutDefault,
                          match: data,
                          completionHandler: nil)
        }
    }

}
