//
//  ContentView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 17/05/24.
//

import SwiftUI

struct MainView: View {
    
    private let onboardingStatusKey = "OnboardingStatus"
    @Environment (\.dismiss) var dismiss
    
    @State var onboardingIsCompleted: Bool = UserDefaults.standard.bool(forKey: "OnboardingStatus")
    @State private var showTutorialView: Bool = false
    
    @Binding var currentStep: Int
    @Binding var skipOnboarding: Bool
    
    @ObservedObject var matchManager: MatchManager
    @ObservedObject var gameLogic: GameLogic
    
    
    var body: some View {
        
        if !onboardingIsCompleted && !skipOnboarding {
            OnboardView(
                onboardingIsCompleted: $onboardingIsCompleted,
                skipOnboarding: $skipOnboarding,
                currentStep: $currentStep)
            .onDisappear {
                if onboardingIsCompleted {
                    UserDefaults.standard.set(true, forKey: onboardingStatusKey)
                }
            }
            
        } else {
            NavigationStack {
                VStack {
                    Text("Tria Tactics")
                        .font(.system(size: 50))
                        .fontWeight(.black)
                        .padding()
                    
                    VStack(spacing: 200) {
                        Text("The game for true tacticians!")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        VStack (spacing: 20) {
                            Button(action: {
                                //placeholder
                            }) {
                                NavigationLink(destination: OnlineView(matchManager: matchManager, gameLogic: gameLogic, currentStep: $currentStep, skipOnboarding: $skipOnboarding)) {
                                    Text("Play Online")
                                        .frame(width: 200, height: 70, alignment: .center)
                                        .background(.yellow)
                                        .foregroundStyle(.black)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .cornerRadius(20)
                                }
                            }
                            .disabled(matchManager.autheticationState != .authenticated || matchManager.inGame)
                            
                            Button(action: {
                                //empty
                            }) {
                                NavigationLink(destination: GameView(gameLogic: gameLogic)) {
                                    Text("Play Offline")
                                        .frame(width: 200, height: 70, alignment: .center)
                                        .background(.yellow)
                                        .foregroundStyle(.black)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .cornerRadius(20)
                                }
                            }
                            
                            Button{
                                showTutorialView = true
                            } label: {
                                Text("Tutorial")
                                    .frame(width: 150, height: 50, alignment: .center)
                                    .background(.yellow)
                                    .foregroundStyle(.black)
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .cornerRadius(20)
                            }
                            .sheet(isPresented: $showTutorialView) {
                                TutorialView()
                            }
                        }
                    }
                    
                }
                
            }
            .onAppear {
                matchManager.authenticateUser()
            }
            .overlay(alignment: .bottom) {
                Text(matchManager.autheticationState.rawValue)
            }
            .tint(.black)
            
        }
    }
}

#Preview {
    MainView(currentStep: .constant(0), skipOnboarding: .constant(false), matchManager: MatchManager(gameLogic: GameLogic()), gameLogic: GameLogic())
}
