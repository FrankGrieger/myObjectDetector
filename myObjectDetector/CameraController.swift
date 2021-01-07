//
//  CameraController.swift
//  myObjectDetector
//
//  Created by Frank Grieger on 06.01.21.
//

import UIKit
import AVFoundation
import CoreData
import Vision


class CameraController: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    var captureSession: AVCaptureSession?
    var captureDevice: AVCaptureDevice?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    enum CameraControllerError: Swift.Error {
        case noSession
        case noDevice
        case noInput
        case notRunning
        case noBuffer
        case noClassifier
        case noModel
        case noViewController
        case unknown
    }

    func prepare(completionHandler: @escaping (Error?) -> Void) {
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
                    completionHandler(error)
                }
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
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
    
    private func captureOutput (_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) throws {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            throw CameraControllerError.noBuffer
        }
        guard let classifier: Resnet50 = try? Resnet50(configuration: MLModelConfiguration()) else {
            throw CameraControllerError.noClassifier
        }
        guard let model = try? VNCoreMLModel(for: classifier.model) else {
            throw CameraControllerError.noModel
        }
        
        let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
            try? self?.processClassifications(for: request, error: error)
        })
        request.imageCropAndScaleOption = .centerCrop
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    func processClassifications(for request: VNRequest, error: Error?) throws {

        DispatchQueue.main.async {
                guard let results = request.results else {
                    //self.classificationLabel.text = "Unable to classify image.\n\(error!.localizedDescription)"
                    return
                }
                // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
                let classifications = results as! [VNClassificationObservation]
        }
    }
}
