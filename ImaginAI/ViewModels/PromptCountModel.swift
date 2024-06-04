//
//  PromptCountModel.swift
//  DalleApp
//
//  Created by Kushagra Shukla on 08/09/23.
//

import Foundation
import SwiftUI

final class PromptCountModel: ObservableObject {
    @Published var promptCount: Int = 8
    func promptUsed() {
        promptCount -= 1
    }
    
}
