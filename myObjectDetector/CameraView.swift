//
//  CameraView.swift
//  myObjectDetector
//
//  Created by Frank Grieger on 19.01.21.
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
            camera.setUpSession()
        })
    }
}

struct CameraPreview: UIViewRepresentable {
    
    @ObservedObject var camera: CameraModel
    
    func makeUIView(context: Context) -> UIView {
        
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.black
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        
        view.layer.addSublayer(camera.preview)
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
