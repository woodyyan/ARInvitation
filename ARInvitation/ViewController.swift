//
//  ViewController.swift
//  ARInvitation
//
//  Created by Songbai Yan on 9/27/16.
//  Copyright © 2016 Songbai Yan. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var viewpreviewLayer : AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        initCamera()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initCamera()
    {
        let cameraDevice : AVCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let  captureDeviceIntput : AVCaptureDeviceInput = try!  AVCaptureDeviceInput(device: cameraDevice)
        let captureOutput: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
        let session = AVCaptureSession()
        if !session.canAddInput(captureDeviceIntput) {
            return
        }
        if !session.canAddOutput(captureOutput) {
            return
        }
        
        session.addInput(captureDeviceIntput)
        session.addOutput(captureOutput)
        
        captureOutput.setMetadataObjectsDelegate(self, queue:DispatchQueue.main)
        
        captureOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        viewpreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        viewpreviewLayer!.frame = view.frame
        view.layer.insertSublayer(viewpreviewLayer!, at: 0)
        
        session.startRunning()
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if let message = metadataObjects.first as? AVMetadataMachineReadableCodeObject, message.type == AVMetadataObjectTypeQRCode && message.stringValue != nil{
            
            // 把坐标转换成为在layer层上面的真实坐标
            let transformObj = self.viewpreviewLayer?.transformedMetadataObject(for: message)
            let qrCodeObj = transformObj as! AVMetadataMachineReadableCodeObject
            print(qrCodeObj.corners)
            
            let corner1 = qrCodeObj.corners.first
            let corner2 = qrCodeObj.corners[1]
            let corner3 = qrCodeObj.corners[2]
            let upperLeftPoint = CGPoint(dictionaryRepresentation: corner1 as! CFDictionary)
            let upperRightPoint = CGPoint(dictionaryRepresentation: corner2 as! CFDictionary)
            let lowerRightPoint = CGPoint(dictionaryRepresentation: corner3 as! CFDictionary)
            let width = (upperRightPoint!.x - upperLeftPoint!.x) + 100
            let height = (upperRightPoint!.y - lowerRightPoint!.y) + 100
            
            print(upperLeftPoint)
            
            // stringValue: 二维码的具体内容
            print(qrCodeObj.stringValue)
            
            if let playerView = self.view.viewWithTag(101) {
                playerView.frame = CGRect(x: upperLeftPoint!.x, y: upperLeftPoint!.y, width: width, height: height)
            }else {
                let redView = UIView(frame: CGRect(x: upperLeftPoint!.x, y: upperLeftPoint!.y, width: width, height: height))
                redView.backgroundColor = UIColor.blue
                //let playerView = PlayerView(frame: CGRect(x: 10, y: 10, width: 200, height: 200))
                redView.tag = 101
                self.view.addSubview(redView)
            }
        }
    }
}

