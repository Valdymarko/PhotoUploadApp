//
//  UploadPhotoService.swift
//  PhotoUploadApp
//
//  Created by Volodymyr Ilkiv on 10.08.2022.
//

import Foundation
import UIKit

// MARK: - UploadPhotoService
final class UploadPhotoService {
    
    // MARK: - Private properties
    private let photo: UIImage
    private let userId: Int
    private let date: String

    private var awsService: AWSService?
    private var firebaseService: FirebaseService?
    private var apiService: APIService?
    
    private lazy var fileName: String = {
        "\(userId)_\(date).jpeg"
    }()
    
    // MARK: - Init
    init(photo: UIImage, userId: Int, date: Date) {
        self.photo = photo
        self.userId = userId
        self.date = DateHelper.getString(from: date, with: .photoFormat)
    }
    
    // MARK: - Public method
    func uploadPhoto(with type: UploadType, completion: @escaping (Error?) -> Void) {
        switch type {
        case .aws:
            guard let url = saveImage(photo, name: fileName) else { return }
            AWSService().uploadPhoto(with: url, name: fileName, completion: completion)
        case .firebase:
            guard let url = saveImage(photo, name: fileName) else { return }
            FirebaseService().uploadPhoto(with: url, name: fileName, completion: completion)
        case .api:
            APIService().uploadImage(image: photo, name: fileName, completion: completion)
        }
    }

    // MARK: - Private method
    private func saveImage(_ image: UIImage, name: String) -> URL? {
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            return nil
        }
        do {
            let imageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(name)
            try imageData.write(to: imageURL)
            return imageURL
        } catch {
            return nil
        }
    }
}
