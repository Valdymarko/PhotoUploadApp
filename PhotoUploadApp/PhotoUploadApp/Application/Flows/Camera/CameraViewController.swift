//
//  CameraViewController.swift
//  PhotoUploadApp
//
//  Created by Volodymyr Ilkiv on 07.08.2022.
//

import UIKit
import AVFoundation

final class CameraViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var actionButton: UIButton!
    
    // MARK: - Private properties
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var stillImageOutput: AVCapturePhotoOutput!
    private var stillImage: UIImage?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkCameraPermissions()
        setupAndStartCaptureSession()
    }
    
    // MARK: - Private methods
    private func setupAndStartCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async{
            self.captureSession = AVCaptureSession()
            self.captureSession.beginConfiguration()
            
            if self.captureSession.canSetSessionPreset(.photo) {
                self.captureSession.sessionPreset = .high
            }
            
            self.captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
            
            self.setupInputAndOutPut()
            
            DispatchQueue.main.async {
                self.setupPreviewLayer()
            }

            self.captureSession.commitConfiguration()
            self.captureSession.startRunning()
        }
    }
    
    private func setupInputAndOutPut() {
        guard let frontCamera =  AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let frontInput = try? AVCaptureDeviceInput(device: frontCamera) else {
            fatalError("Couldn't aaacreate input device from front camera")
        }
        
        if !captureSession.canAddInput(frontInput) {
            fatalError("Couldn't add front camera input to capture session")
        }
        
        captureSession.addInput(frontInput)
        
        stillImageOutput = AVCapturePhotoOutput()
        captureSession.addOutput(stillImageOutput)
    }
    
    private func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.insertSublayer(previewLayer, below: actionButton.layer)
        previewLayer.frame = self.view.layer.frame
    }
    
    private func checkCameraPermissions() {
        let cameraAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthStatus {
        case .authorized:
            return
        case .denied, .restricted:
            abort()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { authorized in
                if !authorized {
                    abort()
                }
            }
        @unknown default:
            fatalError()
        }
    }
    
    // MARK: - IBAction
    @IBAction private func actionButtonTapped(_ sender: UIButton) {
        let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto
        
        stillImageOutput.isHighResolutionCaptureEnabled = true
        stillImageOutput.capturePhoto(with: photoSettings, delegate: self)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else {
            return
        }
        
        stillImage = UIImage(data: imageData)
    }
}
