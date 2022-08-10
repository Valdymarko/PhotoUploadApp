//
//  CameraViewController.swift
//  PhotoUploadApp
//
//  Created by Volodymyr Ilkiv on 07.08.2022.
//

import UIKit

// MARK: - CameraViewController
final class CameraViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var actionButton: UIButton!
    
    // MARK: - Public properties
    var userId: Int?
    
    // MARK: - Private properties
    private var cameraService: CameraService?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraService = CameraService(view: self.view, delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cameraService?.setupAndStartCaptureSession()
    }
    
    // MARK: - Private methods
    private func pushToPhotoPreview(with image: UIImage) {
        let photoPreviewViewController = PhotoPreviewViewController.instantiateFromStoryboard()
        photoPreviewViewController.image = image
        photoPreviewViewController.userId = userId
        self.navigationController?.pushViewController(photoPreviewViewController, animated: true)
    }
    
    // MARK: - IBAction
    @IBAction private func actionButtonTapped(_ sender: UIButton) {
        cameraService?.takePhoto()
    }
}

// MARK: - CameraServiceDelegate
extension CameraViewController: CameraServiceDelegate {
    func getPhoto(_ photo: UIImage) {
        pushToPhotoPreview(with: photo)
    }
}
