# Classifying VideoCapture with Vision and Core ML

Preprocess camera capture using the Vision framework and classify them with a Core ML model.

## Abstract

The application captures the output of the camera continuously, and uses a Mobile ML model to identify objects.

In SwiftUI  camera support is actually relying on the legacy UIKit class. The app uses a UIViewControllerRepresentable instance to create and manage a UIViewController object in the SwiftUI interface. AVCaptureVideoDataOutputSampleBufferDelegate is used to receive captured video sample buffers.
CoreML is used to preprocess the camera output using the Vision framework and to classify it with a ResNet model.

## Concepts

As an inexperienced Swift Developer, I have to give credits to some people that understand more of the subject than I do. At the end of this document you will find a list of sources on the net that I used to create this application. Many thanks to everybody below who helped me to learn about the subject of swift development, how to create a camera app and how to use on device models to implement object recognition.

The application has two major tasks:

1. Capture images from the camera of the iOS device.
2. Use a trained model to classify objects in the field of view of the camera.

One of my design goals was not to use the Storyboard design in xcode, but rather to code my views using SwiftUI.

There are two files in the project that keep my code.

`CamaraModel.swift` is the data model with camera capture logic.

`CameraView.swift` is the simple view to display the capture preview and the observation result. 

### Camera View

The camera view is a simple swift `VStack` which puts a `CameraPreview` view and two `Text` views on top of each other. The `CameraPreview` struct creates the preview view and shows what the camera sees. The two `Text` views are labels to display the recognized object and the estimated confidence of the recognition algorithm in percent.

```swift
VStack{
    CameraPreview(camera: camera)
    Text(identifier)
    Text(confidence)
}
```

### Capture images

1. An instance of `AVCaptureSession()` is needed to manage capture activity and to coordinate the flow of data from input devices to capture outputs.
2. The input `AVCaptureDeviceInput` from the device `AVCaptureDevice` has to be connected to the capture session.
3. The capture data output `AVCaptureVideoDataOutput` has to be observed by all objects that adopt a `AVCaptureVideoDataOutputSampleBufferDelegate` protocol and has to be connected to the capture session too.
4. An instance of `AVCaptureVideoPreviewLayer` has to be added as sublayer to the `CameraView` view to display the device output.

The session is created together with the `CameraModel`. The method `setUpSession()` is called inside `.onAppear` of the `CameraView`. This configures the session when the view appears.

```swift
func setUpSession() {
    
    // create device, input and output
    guard let device = AVCaptureDevice.default(for: .video) else { return }
    guard let input = try? AVCaptureDeviceInput(device: device) else { return }
    let output = AVCaptureVideoDataOutput()
    
    // add input and output to the session
    self.session.addInput(input)
    self.session.addOutput(output)
    
    // let the sample buffer delegate use the video queue to capture images in the background
    output.setSampleBufferDelegate(self, queue: videoQueue)
    
    // start the session
    self.session.startRunning()
}
```

To capture the images from the data output, `CameraModel` adopts the `AVCaptureVideoDataOutputSampleBufferDelegate` protocol.
The method `captureOutput` notifies the delegate that a new video frame was written. The parameter `sampleBuffer` is a `CMSampleBuffer` object containing the video frame data and additional information about the frame.

```swift
func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection)
```
The captured video frame is stored in a `CVPixelBuffer` object in the body of the method `captureOutput`.

```swift
let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
```

### Vision and CoreML

I downloaded a pre trained ResNet50 neural network classifier from the [apple developer site.](https://developer.apple.com/machine-learning/models/) The model of this classifier is in Core ML format.

The `CameraModel` creates an instance of the ResNet50 vision classifier, from which the model can be accessed.

```swift
let visionClassifier: Resnet50 = try! Resnet50(configuration: MLModelConfiguration())
let model = try? VNCoreMLModel(for: visionClassifier.model)
```

A `VNCoreMLRequest` is created. To retrieve the output, a closure is used which has a `request` object that contains a `results` property. This property is an arry of `VNClassificationObservation` objects.
The application picks the first item in the list to read the properties `identifier` and `confidence`. The `VNImageRequestHandler` of the Vision framework is used to perform the `request`.
To publish the changes `DispatchQueue.main.async` is used to return from the background thread.

```swift
let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
    guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
    guard let firstObservation = results.first else { return }
    
    let name: String = firstObservation.identifier
    let conf: VNConfidence = firstObservation.confidence
    
    DispatchQueue.main.async {
        ojectName = name
        resultConfidence = conf
    }
}

try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
```

## Sources

Best way to start out learning swift:
[100 Days of Swift](https://www.hackingwithswift.com/100/swiftui) (Paul Hudson)

Some background on the MVVM design model. Not used in this app :;-) 
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
