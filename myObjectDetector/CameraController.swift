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
        case noSession
        case noDevice
        case noInput
        case notRunning
        case unknown
    }

    func prepare(completion: @escaping (Error?) -> Void) {
        func createCaptureSession() {
            self.captureSession = AVCaptureSession()
        }
        func createCaptureDevice() {
            self.captureDevice = AVCaptureDevice.default(for: .video)
        }
        func startCapture() throws {
            guard let captureSession = self.captureSession else {
                throw CameraControllerError.noSession
            }
            guard let captureDevice = self.captureDevice else {
                throw CameraControllerError.noDevice
            }
            guard let captureInput = try? AVCaptureDeviceInput(device: captureDevice) else {
                throw CameraControllerError.noInput
            }
            
            captureSession.addInput(captureInput)
            captureSession.startRunning()
        }
        
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                createCaptureDevice()
                try startCapture()
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
            throw CameraControllerError.notRunning
        }
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        self.previewLayer?.frame = view.frame
    }
}
