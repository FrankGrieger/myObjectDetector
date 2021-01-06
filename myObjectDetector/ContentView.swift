//
//  ContentView.swift
//  myObjectDetector
//
//  Created by Frank Grieger on 23.12.20.
//

import UIKit
import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var objectName: String = "Object name"
    @State private var accuracy: String = "Accuracy 0%"
    
    var body: some View {
        
        VStack {
            CameraViewController()
            Text(objectName)
            Text(accuracy)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
