//
//  PhotoPreviewViewController.swift
//  PhotoUploadApp
//
//  Created by Volodymyr Ilkiv on 09.08.2022.
//

import UIKit

// MARK: - PhotoPreviewViewController
final class PhotoPreviewViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet private weak var photoImageView: UIImageView!
    
    // MARK: - Public properties
    var image: UIImage?
    var userId: Int?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        photoImageView.image = image
    }
    
    private func pushToUpload() {
        let uploadViewController = UploadViewController.instantiateFromStoryboard()
        uploadViewController.image = image
        uploadViewController.userId = userId
        uploadViewController.date = Date()
        self.navigationController?.pushViewController(uploadViewController, animated: true)
    }

    // MARK: - IBActions
    @IBAction private func retakeButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func continueButtoTapped(_ sender: UIButton) {
        pushToUpload()
    }
}
