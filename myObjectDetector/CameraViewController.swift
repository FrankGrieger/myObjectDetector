//
//  CameraViewController.swift
//  myObjectDetector
//
//  Created by Frank Grieger on 06.01.21.
//

import SwiftUI
import AVFoundation
import Vision

let classification = Classification()
let visionClassifier: Resnet50 = try! Resnet50(configuration: MLModelConfiguration())

class Classification: ObservableObject {
    @Published var object: String = "Object name"
    @Published var confidence: String = "100%"
}

final class CameraViewController: UIViewController {

    let videoQueue = DispatchQueue(label: "VIDEO_QUEUE")
    let captureSession = AVCaptureSession()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = UIColor.black
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        guard let captureInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        
        captureSession.addInput(captureInput)
        captureSession.startRunning()
        
        let captureDataOutput = AVCaptureVideoDataOutput()
        captureDataOutput.setSampleBufferDelegate(self, queue: videoQueue)
        captureSession.addOutput(captureDataOutput)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (captureSession.isRunning) { captureSession.stopRunning() }
    }
}

extension CameraViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = CameraViewController
    
    func makeUIViewController(context: Context) -> CameraViewController {
        return CameraViewController()
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        
    }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        guard let model = try? VNCoreMLModel(for: visionClassifier.model) else { return }
        
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
            guard let firstObservation = results.first else { return }
            
            let name: String = firstObservation.identifier
            let conf: String = "Confidence: \(firstObservation.confidence * 100)"
            DispatchQueue.main.async {
                classification.object = name
                classification.confidence = conf
            }
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}
