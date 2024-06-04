//
//  ArtStyle.swift
//  DalleApp
//
//  Created by Kushagra Shukla on 24/08/23.
//

import Foundation

struct ArtStyle: Identifiable {
    let id = UUID()
    let styleName: String
    let styleImageName: String
    let isPremium: Bool
}
