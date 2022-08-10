//
//  UploadViewController.swift
//  PhotoUploadApp
//
//  Created by Volodymyr Ilkiv on 09.08.2022.
//

import UIKit

// MARK: - UploadViewController
final class UploadViewController: UIViewController {
    
    // MARK: - Public properties
    var image: UIImage?
    var userId: Int?
    var date: Date?
    
    // MARK: - Private methods
    private func uploadPhoto() {
        guard let image = image, let userId = userId, let date = date else {
            return
        }
        let uploadPhotoService = UploadPhotoService(photo: image, userId: userId, date: date)
        uploadPhotoService.uploadPhoto(with: .api) { error in
    
            print(error?.localizedDescription)
            
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    // MARK: - IBAction
    @IBAction func uploadButtonTapped(_ sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        uploadPhoto()
    }
}

