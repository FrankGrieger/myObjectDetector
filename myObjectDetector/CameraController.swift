//
//  CameraController.swift
//  myObjectDetector
//
//  Created by Frank Grieger on 06.01.21.
//

import UIKit
import AVFoundation

class CameraController: NSObject {
    var captureSession: AVCaptureSession?
    var captureDevice: AVCaptureDevice?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    enum CameraControllerError: Swift.Error {
        case noCaptureSession
        case noCaptureDevice
        case noCaptureInput
        case unknown
    }

    func prepare(completion: @escaping (Error?) -> Void) {
        func createCaptureSession() {
            self.captureSession = AVCaptureSession()
        }
        func configureCaptureDevice() throws {
            let captureDevice = AVCaptureDevice.default(for: .video)
            
            try captureDevice?.lockForConfiguration()
            captureDevice?.unlockForConfiguration()
            
            self.captureDevice = captureDevice
        }
        func configureDeviceInput() throws {
            guard let captureSession = self.captureSession else {
                throw CameraControllerError.noCaptureSession
            }
            guard let captureDevice = self.captureDevice else {
                throw CameraControllerError.noCaptureDevice
            }
            guard let captureInput = try? AVCaptureDeviceInput(device: captureDevice) else {
                throw CameraControllerError.noCaptureInput
            }
            
            captureSession.addInput(captureInput)
            captureSession.startRunning()
        }
        
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevice()
                try configureDeviceInput()
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
    func displayPreview(on view: UIView) throws {
        guard let captureSession = self.captureSession, captureSession.isRunning else {
            throw CameraControllerError.noCaptureSession
        }
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        self.previewLayer?.frame = view.frame
    }
}
