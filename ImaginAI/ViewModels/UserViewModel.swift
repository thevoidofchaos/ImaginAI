//
//  UserViewModel.swift
//  DalleApp
//
//  Created by Kushagra Shukla on 02/09/23.
//

import Foundation
import SwiftUI
import RevenueCat

class UserViewModel: ObservableObject {
    @Published var isSubscriptionActive: Bool = false
    
    init(){
        // Using Completion Blocks
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            // access latest customerInfo
            self.isSubscriptionActive = customerInfo?.entitlements[DevelopmentEnviroment.revenueCatOffer]?.isActive == true
            if let error = error as? RevenueCat.ErrorCode {
              print(error.errorCode)
              print(error.errorUserInfo)

              switch error {
              case .purchaseNotAllowedError:
                print("ERROR - Purchases not allowed on this device.")
              case .purchaseInvalidError:
                print("ERROR - Purchase invalid, check payment source.")
              default: break
              }
            } else {
              // Error is a different type
                print("Error is a different type")
            }
        }
    }
}
