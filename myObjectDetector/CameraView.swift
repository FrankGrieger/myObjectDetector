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
            camera.prepareCapture()
        })
    }
}

struct CameraPreview: UIViewRepresentable {
    
    @ObservedObject var camera: CameraModel
        
    func makeUIView(context: Context) -> UIView {
        
        let view = UIView()
        view.backgroundColor = UIColor.black
        
        camera.addPreviewLayer(view)
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        // Whenever the view is updated, adjust the preview frame to fit the view frame
        camera.updatePreviewLayerFrame(uiView)
    }
}
