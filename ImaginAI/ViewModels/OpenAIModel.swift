//
//  NetworkManager.swift
//  DalleApp
//
//  Created by Kushagra Shukla on 07/09/23.
//

import UIKit
import OpenAIKit

@MainActor final class OpenAIModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var errorCode: String?
    @Published var hasError: Bool = false
    
    private var openAI: OpenAI?
    
    func setup(apiKey: String) throws {
        openAI = OpenAI(
            Configuration(
                organizationId: "Personal",
                apiKey: apiKey)
        )
    }
    
    func request(dalleObject: DalleObject, completion: @escaping (Result<[UIImage], Error>) -> Void) async throws {
        guard let openAI = openAI else {
            throw NSError(domain: "OpenAIModel", code: -1, userInfo: ["message": "OpenAI not initialized."])
        }
        
        var imageResolution: ImageResolutions
        
        switch dalleObject.imageQuality {
        case .low:
            imageResolution = .small
        case .medium:
            imageResolution = .medium
        case .high:
            imageResolution = .large
        }
        
        if dalleObject.image == nil {
            do {
                let params = ImageParameters(
                    prompt: dalleObject.prompt!,
                    numberofImages: dalleObject.imageCount,
                    resolution: imageResolution,
                    responseFormat: .base64Json
                )
                
                let result = try await openAI.createImage(parameters: params)
                let images = try result.data.map { imageData in
                    try openAI.decodeBase64Image(imageData.image)
                }
                completion(.success(images))
                
            } catch {
                hasError = true
                handleError(error: error)
                completion(.failure(error))
                
            }
            
        } else {
            
            do {
                let params = try ImageVariationParameters(
                    image: compressImage(image: dalleObject.image)!,
                    numberOfImages: dalleObject.imageCount,
                    resolution: imageResolution,
                    responseFormat: .base64Json
                )
                
                let result = try await openAI.generateImageVariations(parameters: params)
                
                let images = try result.data.map { imageData in
                    try openAI.decodeBase64Image(imageData.image)
                }
                completion(.success(images))
            } catch {
                hasError = true
                handleError(error: error)
                completion(.failure(error))
            }
        }
    }
    
    func handleError(error: Error) {
        if let openAIError = (error as? OpenAIErrorResponse) {
            self.errorMessage = openAIError.error.message
            self.errorCode = openAIError.error.code
        } else {
            errorMessage = error.localizedDescription
        }
    }
    
    func compressImage(image: DalleUniqueImage?) -> UIImage? {
        guard let compressedImageData = image?.dalleImage.jpegData(compressionQuality: 0.2) else {
            return nil
        }
        let image = UIImage(data: compressedImageData)
        return image
    }
}
