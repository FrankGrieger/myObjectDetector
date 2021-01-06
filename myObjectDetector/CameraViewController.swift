//
//  CameraViewController.swift
//  myObjectDetector
//
//  Created by Frank Grieger on 06.01.21.
//

import UIKit
import SwiftUI

final class CameraViewController: UIViewController, UIViewControllerRepresentable {
    
    let cameraController = CameraController()
    var previewView: UIView!
    
    override func viewDidLoad() {
        //previewView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        previewView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        //previewView.contentMode = UIView.ContentMode.scaleAspectFit
        view.backgroundColor = .black
        view.addSubview(previewView)
        
        cameraController.prepare { (error) in
            if let error = error {
                print(error)
            }
            
            try? self.cameraController.displayPreview(on: self.previewView)
        }
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<CameraViewController>) -> CameraViewController {
        return CameraViewController()
    }
        
    public func updateUIViewController(_ uiViewController: CameraViewController, context: UIViewControllerRepresentableContext<CameraViewController>) {
        //some code
    }
}

