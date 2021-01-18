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
    @StateObject var classification: ClassificationViewModel

    var body: some View {

        VStack{
            CameraViewController()
            Text(classification.object)
            Text(classification.confidence)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(classification: ClassificationViewModel())
    }
}
