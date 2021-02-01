//
//  CameraView.swift
//  myObjectDetector
//
//  Created by Frank Grieger on 23.12.20.
//

import Foundation
import SwiftUI
import AVFoundation

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
