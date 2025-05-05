import Flutter
import UIKit
import AVFoundation
import AVKit

extension AVMutableComposition {
    
    func mergeVideo(_ urls: [URL], completion: @escaping (_ url: URL?, _ error: Error?) -> Void) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            completion(nil, nil)
            return
        }
        
        let outputURL = documentDirectory.appendingPathComponent("finalvideo.mp4")

        let url = NSURL(fileURLWithPath: documentDirectory.path)
        if let pathComponent = url.appendingPathComponent("finalvideo.mp4") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                print("FILE AVAILABLE")
                do {
                    try fileManager.removeItem(atPath: pathComponent.path)
                } catch {
                    print("Old file removing error")
                } 
            } else {
                print("FILE NOT AVAILABLE")
            }
        } else {
            print("FILE PATH NOT AVAILABLE")
        }
        
        // If there is only one video, we dont to touch it to save export time.
        print("Count :", urls.count)
        if let url = urls.first, urls.count == 1 {
            do {
                try FileManager().copyItem(at: url, to: outputURL)
                completion(outputURL, nil)
            } catch let error {
                completion(nil, error)
            }
            return
        }
        
        let maxRenderSize = CGSize(width: 1280.0, height: 720.0)
        var currentTime = CMTime.zero
        var renderSize = CGSize.zero
        // Create empty Layer Instructions, that we will be passing to Video Composition and finally to Exporter.
        var instructions = [AVMutableVideoCompositionInstruction]()

        urls.enumerated().forEach { index, url in
            let asset = AVAsset(url: url)
            let assetTrack = asset.tracks.first!
            
            // Create instruction for a video and append it to array.
            let instruction = AVMutableComposition.instruction(assetTrack, asset: asset, time: currentTime, duration: assetTrack.timeRange.duration, maxRenderSize: maxRenderSize)
            instructions.append(instruction.videoCompositionInstruction)
            
            // Set render size (orientation) according first video.
            if index == 0 {
                renderSize = instruction.isPortrait ? CGSize(width: maxRenderSize.height, height: maxRenderSize.width) : CGSize(width: maxRenderSize.width, height: maxRenderSize.height)
            }
            
            do {
                let timeRange = CMTimeRangeMake(start: .zero, duration: assetTrack.timeRange.duration)
                // Insert video to Mutable Composition at right time.
                try insertTimeRange(timeRange, of: asset, at: currentTime)
                currentTime = CMTimeAdd(currentTime, assetTrack.timeRange.duration)
            } catch let error {
                completion(nil, error)
            }
        }
        
        // Create Video Composition and pass Layer Instructions to it.
        let videoComposition = AVMutableVideoComposition()
        videoComposition.instructions = instructions
        // Do not forget to set frame duration and render size. It will crash if you dont.
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        
        videoComposition.renderSize = renderSize
       
        guard let exporter = AVAssetExportSession(asset: self, presetName: AVAssetExportPreset1280x720) else {
            completion(nil, nil)
            return
        }
        
        exporter.outputURL = outputURL
        exporter.outputFileType = .mp4
        // Pass Video Composition to the Exporter.
        exporter.videoComposition = videoComposition
        
        exporter.exportAsynchronously {
            DispatchQueue.main.async {
                completion(exporter.outputURL, nil)
            }
        }
    }
    
    static func instruction(_ assetTrack: AVAssetTrack, asset: AVAsset, time: CMTime, duration: CMTime, maxRenderSize: CGSize)
        -> (videoCompositionInstruction: AVMutableVideoCompositionInstruction, isPortrait: Bool) {
            let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: assetTrack)

            // Find out orientation from preffered transform.
            let assetInfo = orientationFromTransform(assetTrack.preferredTransform)
            
            // Calculate scale ratio according orientation.
            var scaleRatio = maxRenderSize.width / assetTrack.naturalSize.width
            if assetInfo.isPortrait {
                scaleRatio = maxRenderSize.height / assetTrack.naturalSize.height
            }
            
            // Set correct transform.
            var transform = CGAffineTransform(scaleX: scaleRatio, y: scaleRatio)
            transform = assetTrack.preferredTransform.concatenating(transform)
            layerInstruction.setTransform(transform, at: .zero)
            
            // Create Composition Instruction and pass Layer Instruction to it.
            let videoCompositionInstruction = AVMutableVideoCompositionInstruction()
            videoCompositionInstruction.timeRange = CMTimeRangeMake(start: time, duration: duration)
            videoCompositionInstruction.layerInstructions = [layerInstruction]
            
            return (videoCompositionInstruction, assetInfo.isPortrait)
    }
    
    static func orientationFromTransform(_ transform: CGAffineTransform) -> (orientation: UIImage.Orientation, isPortrait: Bool) {
        var assetOrientation = UIImage.Orientation.up
        var isPortrait = false
        
        switch [transform.a, transform.b, transform.c, transform.d] {
        case [0.0, 1.0, -1.0, 0.0]:
            assetOrientation = .right
            isPortrait = true
            
        case [0.0, -1.0, 1.0, 0.0]:
            assetOrientation = .left
            isPortrait = true
            
        case [1.0, 0.0, 0.0, 1.0]:
            assetOrientation = .up
            
        case [-1.0, 0.0, 0.0, -1.0]:
            assetOrientation = .down

        default:
            break
        }
    
        return (assetOrientation, isPortrait)
    }
    
}

public class SwiftFlutterDailogPlugin: NSObject, FlutterPlugin {
    
    
    // In App Purchase
    static var products = [SKProduct]()
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "bubbly_camera", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterDailogPlugin()

    registrar.addMethodCallDelegate(instance, channel: channel)
    
    channel.setMethodCallHandler { (call, result) in
        print("called")
if(call.method == "path"){
    
    //Checks if file exists, removes it if so.
    let path = call.arguments as! String
    if FileManager.default.fileExists(atPath: path) {
        var documentsUrl: URL {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        }
        let fileURL = documentsUrl.appendingPathComponent("myqrcode.png")
        do {
            let imageData = try Data(contentsOf: fileURL)
            UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData)!, nil, nil, nil)
        } catch {
            print("Error loading image : \(error)")
        }
        
//        do {
//            let url = URL(string: path)
//            let imageData = try Data(contentsOf: url!)
//            print(url!, imageData)
//            //UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData)!, nil, nil, nil)
//        } catch {
//            print("Error loading image : \(error)")
//        }
        
//        if let url = URL(string: call.arguments as! String),
//           let data = try? Data(contentsOf: url),
//           let image = UIImage(data: data) {
//            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//        }
        
//        do {
//            try FileManager.default.removeItem(atPath: path)
//            print("Removed old image")
//        } catch let removeError {
//            print("couldn't remove file at path", removeError)
//        }

    }
    
//    Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (timer) in
//        if let url = URL(string: call.arguments as! String),
//                let data = try? Data(contentsOf: url),
//                let image = UIImage(data: data) {
//                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//        }else {
//            print("11111")
//        }
//    }
    }
        if (call.method == "in_app_purchase_id") {
            print(call.arguments)
            
            
            if let productId = call.arguments as? String {
                print("In Product id")
                PKIAPHandler.shared.setProductIds(ids: [productId])
                PKIAPHandler.shared.fetchAvailableProducts {(products)   in
                    print("Product fetched")
                print(products)
                self.products = products.sorted(by: { Int($0.price) < Int($1.price) })
                
                for obj in products {
                    if obj.productIdentifier == productId {
                        PKIAPHandler.shared.purchase(product: obj) { (alert, product, transaction) in
                            if let tran = transaction, let prod = product {
                                //use transaction details and purchased product as you want
                                if tran.error == nil {
                                    channel.invokeMethod("is_success_purchase", arguments: true) { result in
                                        print("######",result)
                                    }
                                     print("Purchase successfully ", productId)
                                } else {
                                    channel.invokeMethod("is_success_purchase", arguments: false)
                                    
                                        print("In App Purchase error")
                                }
                            } else {
                                print("In App Purchase error")
                                channel.invokeMethod("is_success_purchase", arguments: false)
                            }
                        }
                        break
                    }
                }
                
            }
        } else {
            print("Something went wrong to product id arguments")
        }
        }
    }
    
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

    if (call.method == "getPlatformVersion") {
             result("iOS " + UIDevice.current.systemVersion)
         }
         else if (call.method == "showAlertDialog") {
             DispatchQueue.main.async {
                 let alert = UIAlertController(title: "Alert", message: "Hi, My name is flutter", preferredStyle: .alert);
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                 UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil);
             }
         }
   }
  
}

import Flutter
import UIKit
import StoreKit


