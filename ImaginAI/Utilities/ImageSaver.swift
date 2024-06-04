//
//  ImageSaver.swift
//  DalleApp
//
//  Created by Kushagra Shukla on 26/08/23.
//

import UIKit

class ImageSaver: NSObject {
    private var completionHandler: ((String?) -> Void)?
    
    func writeToPhotoAlbum(image: UIImage, completion: @escaping (String?) -> Void) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted(_:didFinishSavingWithError:contextInfo:)), nil)
        self.completionHandler = completion
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")

        if let _ = error {
            let errorMessage = "Please verify app permissions to save photos to the Library in your device's Settings."
            completionHandler?(errorMessage)
        } else {
            completionHandler?(nil)
        }
    }

}
