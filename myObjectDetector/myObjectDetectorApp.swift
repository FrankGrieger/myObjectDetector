//
//  myObjectDetectorApp.swift
//  myObjectDetector
//
//  Created by Frank Grieger on 23.12.20.
//

import SwiftUI

@main
struct myObjectDetectorApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView(classification: classification)
        }
    }
}
