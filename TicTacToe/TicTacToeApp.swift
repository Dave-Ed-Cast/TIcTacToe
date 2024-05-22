//
//  TicTacToeApp.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 17/05/24.
//

import SwiftUI

@main
struct TicTacToeApp: App {
    
    @State var skipOnboarding: Bool = false
    var body: some Scene {
        WindowGroup {
            MainView(onboardingIsCompleted: UserDefaults.standard.bool(forKey: "OnboardingStatus"), skipOnboarding: $skipOnboarding, currentStep: .constant(0))
                .preferredColorScheme(.light)
        }
    }
}
