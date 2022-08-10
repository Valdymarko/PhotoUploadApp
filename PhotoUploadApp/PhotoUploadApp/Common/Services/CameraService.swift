//
//  CameraService.swift
//  PhotoUploadApp
//
//  Created by Volodymyr Ilkiv on 09.08.2022.
//

import UIKit
import AVFoundation

// MARK: - CameraServiceDelegate
protocol CameraServiceDelegate: AnyObject {
    func getPhoto(_ photo: UIImage)
}

// MARK: - CameraService
final class CameraService: NSObject {
    
    // MARK: - Private properties
    private weak var delegate: CameraServiceDelegate?
    private var view: UIView?

    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var stillImageOutput: AVCapturePhotoOutput!
    
    // MARK: - Init
    init(view: UIView?, delegate: CameraServiceDelegate?) {
        self.view = view
        self.delegate = delegate
    }
    
    // MARK: - Public methods
    func setupAndStartCaptureSession() {
        checkCameraPermissions()

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
    
    func takePhoto() {
        let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto
        
        stillImageOutput.connections.first?.isVideoMirrored = true
        stillImageOutput.isHighResolutionCaptureEnabled = true
        stillImageOutput.capturePhoto(with: photoSettings, delegate: self)
    }

    // MARK: - Private methods
    private func setupInputAndOutPut() {
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let frontInput = try? AVCaptureDeviceInput(device: frontCamera) else {
            fatalError("Couldn't create input device from front camera")
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

        if let view = view {
            view.layer.insertSublayer(previewLayer, at: 0)
            previewLayer.frame = view.layer.frame
        }
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
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraService: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            return
        }

        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            return
        }

        delegate?.getPhoto(image)
    }
}
