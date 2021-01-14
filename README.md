# Classifying VideoCapture with Vision and Core ML

Preprocess camera capture using the Vision framework and classify them with a Core ML model.

## Abstract

The application captures the output of the camera continuously and uses a Mobile ML model to identify objects.

In SwiftUI  camera support is actually relying on the legacy UIKit class. The app uses a UIViewControllerRepresentable instance to create and manage a UIViewController object in the SwiftUI interface. AVCaptureVideoDataOutputSampleBufferDelegate is used to receive captured video sample buffers.

CoreML is used to preprocess the camera output using the Vision framework and to classify it with a Core ML model.


## List of Ressources

Best way to start out learning swift:
[100 Days of Swift](https://www.hackingwithswift.com/100/swiftui) (Paul Hudson)

Some background on the MVVM design model. Not used in this app ;-) 
[iOS MVVM Tutorial](https://www.raywenderlich.com/6733535-ios-mvvm-tutorial-refactoring-from-mvc) (Chuck Krutsinger)

A good introduction on how to build a camera app in iOS:
[Making a Custom Camera in iOS](https://medium.com/@barbulescualex/making-a-custom-camera-in-ios-ea44e3087563) (Alex Barbulescu)

Sample code from apple:
[Building a Camera App](https://developer.apple.com/documentation/avfoundation/cameras_and_media_capture/avcam_building_a_camera_app)(apple)

Core ML Framework Documentation:
[Core ML Documentation](https://developer.apple.com/documentation/coreml) (apple)

Some Core ML Classifiers for the use with CoreML:
[Core ML Models](https://developer.apple.com/machine-learning/models/) (apple)

