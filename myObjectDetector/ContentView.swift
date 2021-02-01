//
//  ContentView.swift
//  myObjectDetector
//
//  Created by Frank Grieger on 23.12.20.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var camera = CameraModel()

    var body: some View {
        
        VStack {
            CameraPreview(camera: camera)
            Text(camera.identifier)
            Text(camera.confidence)
        }
        .onAppear(perform: {
            camera.prepareCapture()
        })

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
