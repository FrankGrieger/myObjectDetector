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
    @StateObject var classification: Classification

    var body: some View {

        VStack{
            CameraViewController()
            Text(classification.object)
            Text(classification.confidence)
            /*
            Text($classification.object.wrappedValue)
            Text($classification.confidence.wrappedValue)
             */
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(classification: Classification())
    }
}
