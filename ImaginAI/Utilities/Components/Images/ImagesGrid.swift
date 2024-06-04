//
//  ImagesGrid.swift
//  DalleApp
//
//  Created by Kushagra Shukla on 26/08/23.
//

import SwiftUI

struct ImagesGrid: View {
    let rows: [GridItem] = [GridItem(.fixed(400), spacing: 10)]
    
    @Binding var images: [DalleUniqueImage]?
    @Binding var selectedImage: DalleUniqueImage?
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows, spacing: 10) {
                    ForEach(images ?? [], id: \.id) { image in
                        ImageCell(image: image, selectedImage: $selectedImage, geometry: geometry, images: $images)
                    }
                }
                .padding(images?.count == 1 ? 0 : 5)
            }
        }
        .frame(height: 400)
    }
}


struct ImagesGrid_Preview: PreviewProvider {
    static var previews: some View {
        let dalleImage: [DalleUniqueImage] = [
            DalleUniqueImage(dalleImage: UIImage(imageLiteralResourceName: "JapaneseInk")),
            DalleUniqueImage(dalleImage: UIImage(imageLiteralResourceName: "JapaneseInk")),
            DalleUniqueImage(dalleImage: UIImage(imageLiteralResourceName: "JapaneseInk"))
        ]
        return ImagesGrid(images: .constant(dalleImage), selectedImage: .constant(nil))
    }
}
