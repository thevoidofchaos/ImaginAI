//
//  DevelopmentEnviroment.swift
//  DalleApp
//
//  Created by Kushagra Shukla on 06/09/23.
//

import Foundation

public enum DevelopmentEnviroment {
    enum Keys {
        static let apiKey = "API_KEY"
        static let appName = "APP_NAME"
        static let revenueCatOffer = "REVENUE_CAT_OFFER"
        static let revenueCatApiKey = "REVENUE_CAT_API_KEY"
        static let revenueCatAppID = "REVENUE_CAT_APP_ID"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist not found")
        }
        return dict
    }()
    
    static let apiKey: String = {
        guard let apiKeyString = DevelopmentEnviroment.infoDictionary[Keys.apiKey] as? String else {
            fatalError("API Key not set in plist.")
        }
        return apiKeyString
    }()
    
    static let appName: String = {
        guard let appNameString = DevelopmentEnviroment.infoDictionary[Keys.appName] as? String else {
            fatalError("App Name not set in plist.")
        }
        return appNameString
    }()
    
    static let revenueCatOffer: String = {
        guard let revenueCatOfferString = DevelopmentEnviroment.infoDictionary[Keys.revenueCatOffer] as? String else {
            fatalError("Offer not set in plist.")
        }
        return revenueCatOfferString
    }()
    
    static let revenueCatApiKey: String = {
        guard let revenueCatApiKeyString = DevelopmentEnviroment.infoDictionary[Keys.revenueCatApiKey] as? String else {
            fatalError("Offer not set in plist.")
        }
        return revenueCatApiKeyString
    }()
    
    static let revenueCatAppID: String = {
        guard let revenueCatAppIDString = DevelopmentEnviroment.infoDictionary[Keys.revenueCatAppID] as? String else {
            fatalError("Offer not set in plist.")
        }
        return revenueCatAppIDString
    }()
    
}
