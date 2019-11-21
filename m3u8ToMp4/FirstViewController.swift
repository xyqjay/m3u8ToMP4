//
//  FirstViewController.swift
//  m3u8ToMp4
//
//  Created by Jay on 16/1/22.
//  Copyright © 2016年 imooc. All rights reserved.
//

import UIKit
import AVFoundation
class FirstViewController: UIViewController {
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var playVideoButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var covertVideoFilePath : String?
}

extension FirstViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        playVideoButton.isUserInteractionEnabled = false
        label.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickCovertTS(){
        print("onClickCovertTS()")
        indicator.startAnimating()
        view.isUserInteractionEnabled = false
        label.text = "开始转换"
        var success = true
        //这里测试DEMO  把资源写死了 其实是 ts在iOS上是不被支持的
//        let string1 = Resource.document() + "/1.mp4"
//        let string2 = Resource.document() + "/2.mp4"
        let string1 = Bundle.main.path(forResource: "1", ofType: "mp4")
        let string2 = Bundle.main.path(forResource: "2", ofType: "mp4")
        //ts文件可以在mac下用QuickTime打开，但在iOS平台下却不行，可以学学Mac开发 在OSX平台上试试。
//        let string1 = NSBundle.mainBundle().pathForResource("112", ofType: "ts")
//        let string2 = NSBundle.mainBundle().pathForResource("113", ofType: "ts")
        print(string1!+"\n"+string2!)
        
        let url1 = URL(fileURLWithPath: string1!)
        let url2 = URL(fileURLWithPath: string2!)
        print(url1.absoluteString+"\n"+url2.absoluteString)
        
        let composition = AVMutableComposition()
        
        let compositionTrack1 = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
        compositionTrack1?.preferredVolume = 1.0
        
        let videoAsset1 = AVURLAsset.init(url: url1, options: nil)
        
        let trackArray1 = videoAsset1.tracks(withMediaType: AVMediaType.video)
        print(trackArray1)
        let track1 = trackArray1[0]//这里没做异常处理，遇到不支持的格式时数组为空，比如换成ts文件
        let timeRange1 = CMTimeRangeMake(start: CMTime.zero, duration: videoAsset1.duration)
        do {
            try compositionTrack1?.insertTimeRange(timeRange1, of: track1, at: CMTime.zero)
            
        } catch {
            print("错误1")
            success = false
        }
        
        
        let videoAsset2 = AVURLAsset.init(url: url2, options: nil)
        
        let trackArray2 = videoAsset2.tracks(withMediaType: AVMediaType.video)
        print(trackArray2)
        let track2 = trackArray2[0]
        let timeRange2 = CMTimeRangeMake(start: CMTime.zero, duration: videoAsset2.duration)
        do {
            try compositionTrack1?.insertTimeRange(timeRange2, of: track2, at: CMTime.zero)
            
        } catch {
            print("错误2")
            success = false
        }
        
        if !success{
            indicator.stopAnimating()
            view.isUserInteractionEnabled = true
            label.text = "转换失败"
        }
        
        let exportSession = AVAssetExportSession(asset:composition, presetName: AVAssetExportPresetMediumQuality)
        
        if exportSession != nil{
            let temporaryFileName = generateTemporyVideoFile()
            
            exportSession?.outputURL = URL(fileURLWithPath: temporaryFileName)
            exportSession?.outputFileType = AVFileType.mp4
            print("开始转换")
            exportSession?.exportAsynchronously(completionHandler: { () -> Void in
                //这里非主线程
                DispatchQueue.main.async(execute: { () -> Void in
                    self.indicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                })
                var tmpString = "转换失败"
                if exportSession?.status == AVAssetExportSession.Status.completed{
                    print("输出成功")
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.covertVideoFilePath = temporaryFileName
                        self.playVideoButton.isUserInteractionEnabled = true
                        tmpString = "转换成功 可以播放视频"
                    })

                }else if exportSession?.status == AVAssetExportSession.Status.failed{
                    tmpString = "转换失败"
                }else if exportSession?.status == AVAssetExportSession.Status.cancelled{
                    tmpString = "任务取消"
                }else if exportSession?.status == AVAssetExportSession.Status.exporting{
                    tmpString = "转换ing"
                }else if exportSession?.status == AVAssetExportSession.Status.waiting{
                    tmpString = "等待ing"
                }else{
                    tmpString = "未知错误"
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    self.label.text = tmpString
                })
            })
            
        }
    }
    @IBAction func onClickVovertMP4(){
        print("onClickVovertMP4()")
        onClickCovertTS()
    }
    
    @IBAction func playVideo(){
        print("playVideo()")
        if covertVideoFilePath != nil{
            let url = URL(fileURLWithPath: covertVideoFilePath!)
            playerView.playVideoWithURL(url)
        }
    }
}
extension FirstViewController{
    func generateTemporyVideoFile() -> String{
        var temporaryFileName = Resource.document()
        temporaryFileName = temporaryFileName + "/\(Date().timeIntervalSince1970)" + ".mp4"
        return temporaryFileName
    }
}
