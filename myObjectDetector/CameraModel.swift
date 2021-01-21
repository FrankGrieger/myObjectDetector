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
        
        // Create devide, inpur and output.
        // To find all capture devices one could use a device discovery session: AVCaptureDevice.DiscoverySession(...) instead of the default.
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }
        let output = AVCaptureVideoDataOutput()
        
        // Recognition is more effective with a lower resolution, since model was trained with small pictures (224 x 224).
        session.sessionPreset = .vga640x480
        
        // Add input and output to the session
        self.session.addInput(input)
        self.session.addOutput(output)
        
        // Let the sample buffer delegate use the video queue in the background.
        output.setSampleBufferDelegate(self, queue: videoQueue)
        
        // Start the session.
        self.session.startRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {

        // The captured video frame is stored in a CVPixelBuffer object
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard let model = try? VNCoreMLModel(for: visionClassifier.model) else { return }
        
        
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            
            // Get the results list and the first observation
            guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
            guard let firstObservation = results.first else { return }
            
            // Format string output
            let name: String = firstObservation.identifier
            let conf: String = "Confidence: \(firstObservation.confidence * 100)"
            
            // Return the results from the background thread to the main thread
            DispatchQueue.main.async {
                self.identifier = name
                self.confidence = conf
            }
        }
        
        // Use a VNImageRequestHandler to perform the request
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}
