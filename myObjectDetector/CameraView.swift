//
//  CameraView.swift
//  myObjectDetector
//
//  Created by Frank Grieger on 23.12.20.
//

import Foundation
import SwiftUI
import AVFoundation

struct CameraView: View {
    
    @StateObject var camera = CameraModel()
    
    var body: some View {
        
        VStack {
            CameraPreview(camera: camera)
            Text(camera.identifier)
            Text(camera.confidence)
        }
        .onAppear(perform: {
            
            // Set up the session when the view appears
            camera.setUpSession()
        })
    }
}

struct CameraPreview: UIViewRepresentable {
    
    @ObservedObject var camera: CameraModel
        
    func makeUIView(context: Context) -> UIView {
        
        let view = UIView()
        view.backgroundColor = UIColor.black
        
        // Set up a preview layer that will fill the view but keep the aspect ration of the image
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.videoGravity = .resizeAspectFill
 
        // Add the preview layer as sublayer to the view
        view.layer.addSublayer(camera.preview)
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        // Whenever the view is updated, adjust the preview frame to fit the view frame
        camera.preview.frame = uiView.frame
    }
}
