//
//  FirebaseService.swift
//  PhotoUploadApp
//
//  Created by Volodymyr Ilkiv on 10.08.2022.
//

import Foundation
import FirebaseStorage

// MARK: - FirebaseService
final class FirebaseService {
    
    // MARK: - Private properties
    private let storage = Storage.storage()
    private let storageRef: StorageReference
    
    // MARK: - Init
    init() {
        storageRef = storage.reference()
    }
    
    // MARK: - Public methods
    func uploadPhoto(with url: URL, name: String, completion: @escaping (Error?) -> Void) {
        let imagesRef = storageRef.child("images/\(name).jpg")
        
        let _ = imagesRef.putFile(from: url, metadata: nil) { _, error in
            completion(error)
        }
    }
}
