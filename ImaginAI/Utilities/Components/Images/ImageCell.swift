//
//  ImageCell.swift
//  DalleApp
//
//  Created by Kushagra Shukla on 03/09/23.
//

import SwiftUI

struct ImageCell: View {
    let image: DalleUniqueImage
    @Binding var selectedImage: DalleUniqueImage?
    let geometry: GeometryProxy
    @Binding var images: [DalleUniqueImage]?
    @State private var isShowingAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(uiImage: image.dalleImage)
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 350)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(image.id == selectedImage?.id ? Color.blue : Color.clear, lineWidth: 2)
                )
                .onTapGesture {
                    selectedImage = image
                }
                .onLongPressGesture(minimumDuration: 0.2) {
                    // Empty action for long press, as contextMenu will handle it.
                }
                .contextMenu {
                    Button("Save") {
                        let imageSaver = ImageSaver()
                        imageSaver.writeToPhotoAlbum(image: image.dalleImage, completion: { errorMessage in
                            guard errorMessage != nil else {
                                return
                            }
                            alertMessage = errorMessage!
                            isShowingAlert = true
                        })
                    }
                }
                .alert(isPresented: $isShowingAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
        }
        .frame(width: images?.count == 1 ? geometry.size.width : nil)
    }
}
