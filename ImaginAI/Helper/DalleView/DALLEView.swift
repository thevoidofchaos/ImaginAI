//
//  DALLEView.swift
//  DalleApp
//
//  Created by Kushagra Shukla on 24/08/23.
//

import SwiftUI

struct DALLEView: View {
    @State private var promptText: String = ""
    @State private var isDisabled: Bool = false
    @State private var sliderValue: CGFloat = 1
    @State private var selectedStyle: ArtStyle? = nil
    @State var imageResolutionString: Resolution = Resolution.medium
    @State var isPaywallPresented: Bool = false
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 4) {
                ScrollView(showsIndicators: false) {
                    HStack {
                        Text("Choose an art style")
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.horizontal, 4)
                    
                    ArtStyleGrid(selectedStyle: $selectedStyle, isPremiumActive: $userViewModel.isSubscriptionActive)
                    
                    DalleCustomizationView(sliderValue: $sliderValue, imageResolutionString: $imageResolutionString)
                        .padding(5)
                    TextField("Enter the prompt", text: $promptText)
                        .frame(height: 30)
                        .padding()
                        .background(.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                }
                .keyboardAvoiding()
                
                Spacer()
                
                if !userViewModel.isSubscriptionActive && imageResolutionString == .high {
                    Button(action: {
                        isPaywallPresented = true
                    }) {
                        Text("Premium")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 350, height: 40)
                            .background(Color.blue)
                            .mask(
                                RoundedRectangle(cornerRadius: 30)
                                    .frame(height: 40)
                            )
                    }
                    .disabled(isDisabled)
                    .sheet(isPresented: $isPaywallPresented, content: {
                        PaywallView(isPaywallPresented: $isPaywallPresented)
                    })
                } else {
                    if !promptText.trimmingCharacters(in: .whitespaces).isEmpty {
                        NavigationLink(destination: ImageVariationView(
                            promptText: promptText,
                            selectedStyle: selectedStyle,
                            imageCount: Int(sliderValue),
                            imageResolution: imageResolutionString
                        )) {
                            Text("Generate")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 350, height: 40)
                                .background(Color.blue)
                                .mask(
                                    RoundedRectangle(cornerRadius: 30)
                                        .frame(height: 40)
                                )
                        }
                        .disabled(isDisabled)
                    }
                }
            } //:VSTACK
            .navigationTitle(DevelopmentEnviroment.appName)
        } //:NAVIGATIONSTACK
    }
}


struct DALLEView_Preview: PreviewProvider {
    static var previews: some View {
        DALLEView()
    }
}

