//
//  CameraModel.swift
//  myObjectDetector
//
//  Created by Frank Grieger on 23.12.20.
//

//import Foundation
import SwiftUI
import AVFoundation
import Vision

class CameraModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {

    let session = AVCaptureSession()
    let videoQueue = DispatchQueue(label: "VIDEO_QUEUE")
    let visionClassifier: Resnet50 = try! Resnet50(configuration: MLModelConfiguration())

    @Published var preview: AVCaptureVideoPreviewLayer!
    @Published var identifier = "Frank"
    @Published var confidence = "Not so sure!"
    
    func setUpSession() {
        
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }
        let output = AVCaptureVideoDataOutput()
        
        self.session.addInput(input)
        self.session.addOutput(output)
        
        output.setSampleBufferDelegate(self, queue: videoQueue)
        
        self.session.startRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {

        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        guard let model = try? VNCoreMLModel(for: visionClassifier.model) else { return }
        
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
            guard let firstObservation = results.first else { return }
            
            let name: String = firstObservation.identifier
            let conf: String = "Confidence: \(firstObservation.confidence * 100)"
            
            DispatchQueue.main.async {
                self.identifier = name
                self.confidence = conf
            }
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}
