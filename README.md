# Classifying VideoCapture with Vision and Core ML

Preprocess camera capture using the Vision framework and classify them with a Core ML model.

## Abstract

The application captures the output of the camera continuously and uses a Mobile ML model to identify objects.

In SwiftUI  camera support is actually relying on the legacy UIKit class. The app uses a UIViewControllerRepresentable instance to create and manage a UIViewController object in the SwiftUI interface. AVCaptureVideoDataOutputSampleBufferDelegate is used to receive captured video sample buffers.

CoreML is used to preprocess the camera output using the Vision framework and to classify it with a Core ML model.


## List of Ressources

[100 Days of Swift](https://www.hackingwithswift.com/100/swiftui) (Paul Hudson)

[iOS MVVM Tutorial](https://www.raywenderlich.com/6733535-ios-mvvm-tutorial-refactoring-from-mvc) (Chuck Krutsinger)

[Making a Custom Camera in iOS](https://medium.com/@barbulescualex/making-a-custom-camera-in-ios-ea44e3087563) (Alex Barbulescu)

[Core ML Models](https://developer.apple.com/machine-learning/models/) (apple)

