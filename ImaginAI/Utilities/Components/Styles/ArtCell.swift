//
//  ArtCell.swift
//  DalleApp
//
//  Created by Kushagra Shukla on 03/09/23.
//

import SwiftUI

struct ArtCell: View {
    var style: ArtStyle
    @Binding var selectedStyle: ArtStyle? 
    @Binding var isPremiumActive: Bool
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .center) {
                Image(style.styleImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(style.id == selectedStyle?.id ? Color.blue : Color.clear, lineWidth: 2)
                    )
                    .onTapGesture {
                        if isPremiumActive == true {
                            selectedStyle = style
                        }
                    }
                Text(style.styleName)
                    .font(.subheadline)
                    .frame(width: 150)
                    .lineLimit(1)
            }
            .padding(2)
            Image("crown")
                .resizable()
                .scaledToFit()
                .frame(width: 30)
                .padding(4)
                .opacity(isPremiumActive == false && style.isPremium ? 1 : 0)
        }
    }
}
