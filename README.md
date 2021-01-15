# Classifying VideoCapture with Vision and Core ML

Preprocess camera capture using the Vision framework and classify them with a Core ML model.

## Abstract

The application captures the output of the camera continuously, and uses a Mobile ML model to identify objects.

In SwiftUI  camera support is actually relying on the legacy UIKit class. The app uses a UIViewControllerRepresentable instance to create and manage a UIViewController object in the SwiftUI interface. AVCaptureVideoDataOutputSampleBufferDelegate is used to receive captured video sample buffers.
CoreML is used to preprocess the camera output using the Vision framework and to classify it with a ResNet model.

## Concepts

As an inexperienced Swift Developer, I have to give credits to some people that understand more of the subject than I do. At the end of this document you will find a list of sources on the net that I used to create this application. Many thanks to everybody below who helped me to learn about the subject of swift development, how to create a camera app and how to use on device models to implement object recognition.

The application has two major tasks:

1. Capture images from the camera of the iOS device
2. Use a trained model to classify objects in the field of view of the camera

One of my design goals was not to use the Storyboard design in xcode, but rather to code my views using SwiftUI.

There are two files in the project that keep my code.

`ContentView.swift` is the very simple main view of the application.

`CameraViewController.swift` is the file that keeps all the logic. 

### Application View

The application view is a simple swift `VStack` which puts a `CameraViewController` view and two `Text` views on top of each other. The `CameraViewController` view displays what the camera sees. The two `Text` views are labels to display the recognized object and the extimated confidence of the recognition algorithm in percent.

```javascript
VStack{
    CameraViewController()
    Text(classification.object)
    Text(classification.confidence)
}
```

### Capture images

### Vision and CoreML

## Sources

Best way to start out learning swift:
[100 Days of Swift](https://www.hackingwithswift.com/100/swiftui) (Paul Hudson)

Some background on the MVVM design model. Not used in this app ;-) 
[iOS MVVM Tutorial](https://www.raywenderlich.com/6733535-ios-mvvm-tutorial-refactoring-from-mvc) (Chuck Krutsinger)

A good introduction on how to build a camera app in iOS:
[Making a Custom Camera in iOS](https://medium.com/@barbulescualex/making-a-custom-camera-in-ios-ea44e3087563) (Alex Barbulescu)

Also nice to learn about camera apps on iOS devices:
[How to Build a Camara App With SwiftUI](https://medium.com/better-programming/effortless-swiftui-camera-d7a74abde37e) (Rolando Rodriguez)

Sample code from apple:
[Building a Camera App](https://developer.apple.com/documentation/avfoundation/cameras_and_media_capture/avcam_building_a_camera_app)(apple)

Some background on ResNet:
[An Overview of ResNet and its Variants](https://towardsdatascience.com/an-overview-of-resnet-and-its-variants-5281e2f56035) (Vincent Fung)

Core ML Framework Documentation:
[Core ML Documentation](https://developer.apple.com/documentation/coreml) (apple)

Some Core ML Classifiers for the use with CoreML:
[Core ML Models](https://developer.apple.com/machine-learning/models/) (apple)

