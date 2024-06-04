//
//  Resolution.swift
//  DalleApp
//
//  Created by Kushagra Shukla on 03/09/23.
//

import Foundation

enum Resolution {
    case low
    case medium
    case high
    
    var resolutionString: String {
        switch self {
        case .low: return "256x256"
        case .medium: return "512x512"
        case .high: return "1048x1048"
        }
    }
}

