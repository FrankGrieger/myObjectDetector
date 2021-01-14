//
//  CameraViewController.swift
//  myObjectDetector
//
//  Created by Frank Grieger on 06.01.21.
//

import UIKit
import SwiftUI
import AVFoundation

var classification = Classification()

class Classification: ObservableObject {
    @Published var object: String
    @Published var confidence: String

    init() {
        object = "Object name"
        confidence = "100%"
    }
}

final class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

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
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        DispatchQueue.main.async {
            classification.object = "Frank"
            classification.confidence = "not so sure!"
        }
    }
}

extension CameraViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = CameraViewController
    
    func makeUIViewController(context: Context) -> CameraViewController {
        return CameraViewController()
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        uiViewController.view.updateConstraints()
    }
}
