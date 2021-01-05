//
//  ContentView.swift
//  myObjectDetector
//
//  Created by Frank Grieger on 23.12.20.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var objectName: String = "Object name"
    @State private var accuracy: String = "Accuracy 0%"
    
    var body: some View {
        let captureSession = AVCaptureSession()
        
        VStack {
            CameraPreview(session: captureSession)
            //Image("Photos-new-icon")
            Text(objectName)
            Text(accuracy)
        }
        .padding()
        .onAppear() {
            guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
            guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
            captureSession.addInput(input)
            captureSession.startRunning()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// create a camera preview view
struct CameraPreview: UIViewRepresentable {
    // create a UIView subclass
    
    class VideoPreviewView: UIView {
        //We wan't the view's core animation layer to be of type AVCaptureVideoPreviewLayer
        //That is why we override the UIView's layer type
        override class var layerClass: AnyClass {
            // set it to AVCaptureVideoPreviewLayer
            AVCaptureVideoPreviewLayer.self
        }
        // create a get-only property that returns the UIView's layer cast as AVCaptureVideoPreviewLayer
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }
    
    // struct will have a capture session
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        view.backgroundColor = .black
        view.videoPreviewLayer.session = session

        return view
    }
    
    func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        //some code
    }
}
