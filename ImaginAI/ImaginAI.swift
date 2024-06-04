//
//  ImaginAI.swift
//  DalleApp
//
//  Created by Kushagra Shukla on 24/08/23.
//

import SwiftUI
import RevenueCat

@main
struct ImaginAI: App {
    @StateObject var userViewModel = UserViewModel()
    var body: some Scene {
        WindowGroup {
            DALLEView()
                .environmentObject(userViewModel)
        }
    }
    init() {
        /// - Prints any error related to the communication between RevenueCat and AppStoreConnect
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: DevelopmentEnviroment.revenueCatApiKey, appUserID: DevelopmentEnviroment.revenueCatAppID)
    }
}
