//
//  S3Uploader.swift
//  stepfund1
//
//  Created by satish prajapati on 14/08/25.
//

import Foundation
import UIKit
import AWSS3

class S3Uploader {
    
    // Change these to match your AWS setup
    private let bucketName = "walkearn"
    private let region = AWSRegionType.APSouth1 // Change to your region

    func uploadImage(image: UIImage,folder: String, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "S3Uploader", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"])))
            return
        }

        let uuid = UUID().uuidString
        let fileName = "\(folder)/\(uuid).jpg"

        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.setValue("public-read", forRequestHeader: "x-amz-acl")
        
        expression.progressBlock = { (_, progress) in
            print("Upload progress: \(progress.fractionCompleted)")
        }

        let transferUtility = AWSS3TransferUtility.default()
        
        transferUtility.uploadData(imageData,
                                   bucket: bucketName,
                                   key: fileName,
                                   contentType: "image/jpeg",
                                   expression: expression) { task, error in
            if let error = error {
                completion(.failure(error))
            } else {
                // Build the final image URL
                let urlString = "https://\(self.bucketName).s3.amazonaws.com/\(fileName)"
                if let url = URL(string: urlString) {
                    completion(.success(url))
                } else {
                    completion(.failure(NSError(domain: "S3Uploader", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to construct URL"])))
                }
            }
        }
    }
}
