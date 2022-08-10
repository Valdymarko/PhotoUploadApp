//
//  APIService.swift
//  PhotoUploadApp
//
//  Created by Volodymyr Ilkiv on 10.08.2022.
//

import Foundation
import UIKit

// MARK: - APIService
final class APIService {
    
    // MARK: - Constants
    private let baseUrl = "https://someapi/api/uploadfile"
    
    // MARK: - Init
    init() { }
    
    // MARK: - Public method
    func uploadImage(image: UIImage, name: String, completion: @escaping (Error?) -> Void) {
        let url = URL(string: baseUrl)

        let boundary = UUID().uuidString
        let session = URLSession.shared

        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"

        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()

        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; filename=\"\(name)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.jpegData(compressionQuality: 1)!)

        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        session.uploadTask(with: urlRequest, from: data, completionHandler: { _, _, error in
            completion(error)
        }).resume()
    }
}
