//
//  MatchManager.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 22/05/24.
//

import Foundation
import GameKit
import SwiftUI

class MatchManager: NSObject, ObservableObject {
    
    @Published var inGame: Bool = false
    @Published var isGameOver: Bool = false
    @Published var autheticationState: PlayerAuthState = .authenticating
    @Published var currentlyPlaying: Bool = false
    @Published var score: Int = 0
    @Published var lastIndexReceived: Int = 0
    @Published var isTimeKeeper: Bool = false
    @Published var remainingTime = 10
        
    var match: GKMatch?
    var localPlayer: GKLocalPlayer = GKLocalPlayer.local
    var otherPlayer: GKPlayer?
    var playerUUIDKey = UUID().uuidString
    var rootViewController: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }
    
    var gameLogic: GameLogic?
    
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
        
        let matchMakerVC = GKMatchmakerViewController(matchRequest: request)
        matchMakerVC?.matchmakerDelegate = self
        rootViewController?.present(matchMakerVC!, animated: true)
    }
    
    func startGame(newMatch: GKMatch) {
        match = newMatch
        match?.delegate = self
        otherPlayer = match?.players.first
        currentlyPlaying = true
        sendString("began:\(playerUUIDKey)")
    }
    
    func sendMove(index: Int, player: Player) {
        let moveMessage = "move:\(index):\(player)"
        sendString(moveMessage)
    }
    
    func swapActivePlayer() {
        currentlyPlaying = !currentlyPlaying
    }
    
    func gameOver() {
        isGameOver = true
        match?.disconnect()
    }
    
    func resetGame() {
        gameLogic?.resetGame()
        isTimeKeeper = false
        match?.delegate = nil
        match = nil
        otherPlayer = nil
        playerUUIDKey = UUID().uuidString
    }
    
    func receivedString(_ message: String) {
        let messageSplit = message.split(separator: ":")
        guard let messagePrefix = messageSplit.first else { return }
        
        let parameter = String(messageSplit.last ?? "")
        
        switch messagePrefix {
        case "began":
            if playerUUIDKey == parameter {
                playerUUIDKey = UUID().uuidString
                sendString("began:\(playerUUIDKey)")
                break
            }
            
            currentlyPlaying = playerUUIDKey < parameter
            inGame = true
            isTimeKeeper = true
            
            if isTimeKeeper {
                countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            }
        case "move":
            if messageSplit.count == 3, let index = Int(messageSplit[1]), let playerSymbol = messageSplit[2].first, let player = Player(rawValue: String(playerSymbol)) {
                gameLogic?.receiveMove(index: index, player: player)
                currentlyPlaying = playerUUIDKey != player.rawValue
                print("Move received, currentlyPlaying: \(currentlyPlaying)")
            }
        default:
            break
        }
    }
}
