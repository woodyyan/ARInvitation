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
        // 判断输入源能否添加到捕捉任务中
        if !session.canAddInput(captureDeviceIntput) {
            return
        }
        // 判断输出源能否添加到捕捉任务中
        if !session.canAddOutput(captureOutput) {
            return
        }
        
        //添加两个源
        session.addInput(captureDeviceIntput)
        session.addOutput(captureOutput)
        
        //设置输出源的代理和队列
        captureOutput.setMetadataObjectsDelegate(self, queue:DispatchQueue.main)
        
        //设置源数据类型  当前使用的是:二维码类型
        captureOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        viewpreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        
        //设置图层大小
        viewpreviewLayer!.frame = view.frame
        
        view.layer.insertSublayer(viewpreviewLayer!, at: 0)
        
        //这句话忘了写什么都没有
        session.startRunning()
    }
    
    //扫描时的数据代理
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        //判断转化为AVMMRCO后的数组的第一个对象是否为空，不为空赋值给message，message类型是否为AVMetadataObjectTypeQRCode(二维码类型)和meesage的字符串值不为nil
        if let message = metadataObjects.first as? AVMetadataMachineReadableCodeObject, message.type == AVMetadataObjectTypeQRCode && message.stringValue != nil{
            
            if let _ = self.view.viewWithTag(101) {
                
            }else {
                let playerView = PlayerView(frame: CGRect(x: 10, y: 10, width: 200, height: 200))
                playerView.tag = 101
                self.view.addSubview(playerView)
            }
//            let alert = UIAlertController(title: "二维码内容", message: message.stringValue, preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
//            self.present(alert, animated: true, completion: nil)
        }
    }
}

