//
//  AWSService.swift
//  PhotoUploadApp
//
//  Created by Volodymyr Ilkiv on 10.08.2022.
//

import Foundation
import AWSCore
import AWSS3

// MARK: - AWSService
final class AWSService {
    
    // MARK: - Constants
    private let accessKey = "accessKey"
    private let secretAccessKey = "secretAccessKey"
    private let bucketName = "pm-bucketName"
    private let fileName = "FotaSettings.json"
    private let awsRegion = AWSRegionType.USEast1
    private let url = URL(string: "https://someurl.com")
    
    // MARK: - Init
    init() {
        defaultAWSServiceConfiguration()
    }
    
    // MARK: - AWSServiceConfiguration
    private func defaultAWSServiceConfiguration() {
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretAccessKey)
        let configuration = AWSServiceConfiguration(
            region: awsRegion,
            credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }

    // MARK: - Uploading objects
    func uploadPhoto(with url: URL, name: String, completion: @escaping (Error?) -> Void) {
        let progressBlock: AWSS3TransferUtilityProgressBlock =  { (task, progress) in
            DispatchQueue.main.async {
                print(task)
            }
        }

        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = progressBlock

        let transferUtility = AWSS3TransferUtility.default()
        let completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock = { (task, error) -> Void in
            DispatchQueue.main.async {
                completion(error)
            }
        }

        let contentType = "image/jpeg"

        transferUtility.uploadFile(
            url,
            bucket: bucketName,
            key: name,
            contentType: contentType,
            expression: expression,
            completionHandler: completionHandler)
    }
}
