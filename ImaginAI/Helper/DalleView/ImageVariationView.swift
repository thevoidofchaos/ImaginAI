//
//  ImagePromptView.swift
//  DalleApp
//
//  Created by Kushagra Shukla on 24/08/23.
//

import SwiftUI

struct ImageVariationView: View {
    @State private var sliderValue: CGFloat = 1
    @State private var selectedImage: DalleUniqueImage? = nil
    @EnvironmentObject var userViewModel: UserViewModel
    
    var promptText: String
    var selectedStyle: ArtStyle?
    var imageCount: Int?
    @ObservedObject var openAIModel = OpenAIModel()
    @ObservedObject var promptCountModel = PromptCountModel()
    
    @State private var isDisabled: Bool = false
    @State private var isLoading: Bool = true
    @State private var isPaywallPresented: Bool = false
    @State private var isPromptEmpty: Bool = false
    @State private var alertMessage: String = ""
    
    @State private var imageResolutionString: Resolution = Resolution.medium
    var imageResolution: Resolution = Resolution.medium
    
    @State var dalleImages: [DalleUniqueImage]?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            showProgress()
            
            if !isLoading {
                VStack(alignment: .center, spacing: 4) {
                    ScrollView(showsIndicators: false) {
                        ImagesGrid(images: $dalleImages, selectedImage: $selectedImage)
                        
                        DalleCustomizationView(sliderValue: $sliderValue, imageResolutionString: $imageResolutionString)
                            .padding(5)
                    } //:VSTACK
                    
                    Spacer()
                    
                    Button {
                        if userViewModel.isSubscriptionActive {
                            guard selectedImage != nil else {return}
                            isDisabled = true
                            isLoading = true
                            Task {
                                await generateVariations()
                            }
                        } else {
                            isPaywallPresented = true
                        }
                    }label: {
                        Text("Generate Variations")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 350, height: 40)
                            .background(selectedImage == nil ? .gray : .blue)
                            .mask(
                                RoundedRectangle(cornerRadius: 30)
                                    .frame(height: 40)
                            )
                    }
                    .disabled(isDisabled)
                }
            }
        } //:ZSTACK
        .sheet(isPresented: $isPaywallPresented, content: {
            PaywallView(isPaywallPresented: $isPaywallPresented)
        })
        .alert("Error",
               isPresented: $openAIModel.hasError,
               actions: {},
               message: {Text(openAIModel.errorMessage ?? "")}
        )
        .onAppear {
            if userViewModel.isSubscriptionActive == true {
                Task {
                    await generateImage()
                }
            } else {
                if promptCountModel.promptCount >= 1 {
                    Task {
                        await generateImage()
                    }
                } else {
                    isLoading = false
                    isPromptEmpty = true
                    alertMessage = "You are out of prompts. Subscribe to Premium to enjoy unlimited prompts."
                }
            }
        }
    }
}

struct ImageVariationView_Preview: PreviewProvider {
    static var previews: some View {
        ImageVariationView(promptText: "Spaceship")
    }
}


extension ImageVariationView {
    
    func showProgress() -> some View {
        return ProgressView(label: {
            Text("Generating")
        })
        .progressViewStyle(.circular)
        .disabled(isLoading)
        .opacity(isLoading == true ? 1 : 0)
        .alert(isPresented: $isPromptEmpty) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    
    func generateImage() async {
        dalleImages = []
        try? openAIModel.setup(apiKey: DevelopmentEnviroment.apiKey)
        
        var prompt = promptText
        prompt.append(" \(selectedStyle?.styleName ??  " ")")
        
        let dalleObject = DalleObject(prompt: prompt, imageCount: imageCount!, imageQuality: imageResolution, image: nil)
        try? await openAIModel.request(dalleObject: dalleObject) { res in
            switch res {
            case .success(let images):
                for image in images {
                    let dalleImage = DalleUniqueImage(dalleImage: image)
                    dalleImages?.append(dalleImage)
                }
                isLoading = false
                isDisabled = false
                promptCountModel.promptUsed()
            case .failure(_):
                isLoading = false
            }
        }
    }
    
    func generateVariations() async {
        dalleImages = []
        dalleImages?.append(selectedImage!)
        let dalleObject = DalleObject(prompt: nil, imageCount: Int(sliderValue), imageQuality: imageResolutionString, image: selectedImage!)
        try? await openAIModel.request(dalleObject: dalleObject) { res in
            switch res {
            case .success(let images):
                for image in images {
                    let dalleImage = DalleUniqueImage(dalleImage: image)
                    dalleImages?.append(dalleImage)
                }
                isLoading = false
                isDisabled = false
            case .failure(_):
                isLoading = false
            }
        }
    }
}
