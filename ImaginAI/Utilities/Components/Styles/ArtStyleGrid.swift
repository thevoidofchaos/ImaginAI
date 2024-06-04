//
//  ArtStyleGrid.swift
//  DalleApp
//
//  Created by Kushagra Shukla on 24/08/23.
//

import SwiftUI

struct ArtStyleGrid: View {
    let rows: [GridItem] = [
        GridItem(.fixed(150), spacing: 0)
    ]
    
    var styles: [ArtStyle] = artStyles
    @Binding var selectedStyle: ArtStyle?
    @Binding var isPremiumActive: Bool
    
    var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem()]) {
                    ForEach(styles, id: \.id) { style in
                        ArtCell(style: style, selectedStyle: $selectedStyle, isPremiumActive: $isPremiumActive)
                    }
                } //:LAZYHGRID
                .frame(height: 200)
            } //:SCROLLVIEW
    }
}

struct ArtStyleGrid_Preview: PreviewProvider {
    static var previews: some View {
        ArtStyleGrid(styles: artStyles, selectedStyle: .constant(nil), isPremiumActive: .constant(true))
            .previewLayout(.sizeThatFits)
    }
}
