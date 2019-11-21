//
//  PlayerView.swift
//  m3u8ToMp4
//
//  Created by Jay on 16/1/22.
//  Copyright © 2016年 imooc. All rights reserved.
//

import UIKit
import AVFoundation
class PlayerView: UIView {
    let toolBar = Bundle.main.loadNibNamed("PlayerViewToolBar",
        owner: nil,
        options: nil)!.first as! PlayerViewToolBar
    
    var playerViewControllerKVOContext = 0

    lazy var player = AVQueuePlayer()
    
    weak var delegate: PlayerDelegate?

    static let assetKeysRequiredToPlay = [
        "playable",
        "hasProtectedContent"
    ]
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
        backgroundColor = UIColor.black
        
        let selfLayer = layer as! AVPlayerLayer
        selfLayer.player = player
        
        setupPlayerPeriodicTimeObserver()
        addObserver()

        initToolBar()
        
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
//    private var player : AVQueuePlayer?{
//        didSet{
//            let selfLayer = layer as! AVPlayerLayer
//            selfLayer.player = player
//        }
//    }
    
    var loadingState: Bool = false {
        didSet {
            if loadingState {

            } else {

            }
        }
    }
    
    // MARK: Time
    
    var timeObserverToken: AnyObject?
    
   override class var layerClass : AnyClass {
        return AVPlayerLayer.self
    }

    deinit {
//        removeObserver(self, forKeyPath: "player.currentItem.duration")
//        removeObserver(self, forKeyPath: "player.rate")
//        removeObserver(self, forKeyPath: "player.currentItem.status")
    }
}
extension PlayerView{
    
    func playVideoWithURL(_ url:URL){
        let asset = AVURLAsset(url: url, options: nil)
        let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: PlayerView.assetKeysRequiredToPlay)
//        let playerItem = AVPlayerItem.init(URL: url)
//        addObserverForItem(playerItem)
        player.replaceCurrentItem(with: playerItem)

//        player = AVQueuePlayer.init(playerItem: playerItem)
//        addObserverForPlayer()
        
        player.rate = 1.0
    }
    
    func addItem(_ url:URL){
        let asset = AVURLAsset(url: url, options: nil)
        let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: PlayerView.assetKeysRequiredToPlay)
//        let playerItem = AVPlayerItem.init(URL: url)
//        addObserverForItem(playerItem)

        player.insert(playerItem, after: player.currentItem)
    }
    func addObserver(){
//        player.observe(\AVQueuePlayer.rate, options: [.new, .initial]) { (player_, change) in
//            //
//            print("\(change)")
//        }
//        player.addObserver(self, forKeyPath: "rate", options: [.new, .initial], context: &playerViewControllerKVOContext)
//        player.addObserver(self, forKeyPath: "currentItem.duration", options: [.new, .initial], context: &playerViewControllerKVOContext)
//        player.addObserver(self, forKeyPath: "currentItem.status", options: [.new, .initial], context: &playerViewControllerKVOContext)
    }
    
    var duration: Double {
        guard let currentItem = player.currentItem else { return 0.0 }
        var seconds = Double(0.0)
        // MARK 前一个Item播完就会被释放，player.items()就少一个，这个BUG先忽略，本Demo不是完整的视频播放解决方案，而是测试研究视频播放，学习swift使用，随着慢慢的完善可能最终会出个完整的视频播放器
        let items = player.items()
        for item in items{
            seconds += CMTimeGetSeconds(item.duration)
        }
        return seconds
        return CMTimeGetSeconds(currentItem.duration)
    }
    
    func streamProgress() -> Double {
        func availableDuration() -> Double
        {
            if let range = player.currentItem?.loadedTimeRanges.first {
                return CMTimeGetSeconds(CMTimeRangeGetEnd(range.timeRangeValue))
            }
            return 0
        }
        
        return (duration == 0) ? (duration) : (availableDuration() / duration)
    }
    
    /*
    func addObserverForPlayer(){
        player?.addObserver(self,
            forKeyPath: "externalPlaybackActive",
            options: NSKeyValueObservingOptions.New,
            context: nil)
        
        player?.addObserver(self,
            forKeyPath: "rate",
            options: .New,
            context: nil)
    }
    
    func addObserverForItem(playerItem : AVPlayerItem){
        playerItem.addObserver(self,
            forKeyPath: "status",
            options: .New,
            context: nil)
        
        playerItem.addObserver(self,
            forKeyPath: "playbackBufferEmpty",
            options: .New,
            context: nil)
        
        playerItem.addObserver(self,
            forKeyPath: "playbackLikelyToKeepUp",
            options: .New,
            context: nil)
        
        playerItem.addObserver(self,
            forKeyPath: "loadedTimeRanges",
            options: .New,
            context: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("playerItemDidReachEnd:"), name: "", object: playerItem)
    }
*/
    
    func cleanUpPlayerPeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    func setupPlayerPeriodicTimeObserver() {
        guard timeObserverToken == nil else { return }
        
        let time = CMTimeMake(value: 1, timescale: 1)
        
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: time, queue:DispatchQueue.main) {
            [weak self] timex in
            if let weakSelf = self {
                if weakSelf.duration != 0 {
                    weakSelf.toolBar.currentValue(Float(CMTimeGetSeconds(timex) / weakSelf.duration))
                    weakSelf.toolBar.updateTimelabel(CMTimeGetSeconds(timex), totalTime: weakSelf.duration)
                }
            }
        } as AnyObject?
    }
}

extension PlayerView{
    func playerItemDidReachEnd(_ notification :Notification){
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &playerViewControllerKVOContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if keyPath == "player.rate" {
            let newRate = (change?[NSKeyValueChangeKey.newKey] as! NSNumber).doubleValue
            if newRate == 0.0 {
                toolBar.isPlaying(false)
            } else {
                toolBar.isPlaying(true)
            }

        }else if keyPath == "player.currentItem.duration" {
            let newDuration: CMTime
            if let newDurationAsValue = change?[NSKeyValueChangeKey.newKey] as? NSValue {
                newDuration = newDurationAsValue.timeValue
            }
            else {
                newDuration = CMTime.zero
            }
            let hasValidDuration = newDuration.isNumeric && newDuration.value != 0
            
            let currentTime = CMTimeGetSeconds(player.currentTime())
            
//            toolBar.currentValue(Float(hasValidDuration ? currentTime / duration : 0.0))
        }else if keyPath == "player.currentItem.status" {
            let newStatus: AVPlayerItem.Status
            if let newStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
                newStatus = AVPlayerItem.Status(rawValue: newStatusAsNumber.intValue)!
            }
            else {
                newStatus = .unknown
            }
            
            if newStatus == .failed {
                loadingState = false
                //MARK
                //播放失败
            }
            else if newStatus == .readyToPlay {
                loadingState = false
                if let asset = player.currentItem?.asset {
                    
                    for key in PlayerView.assetKeysRequiredToPlay {
                        var error: NSError?
                        if asset.statusOfValue(forKey: key, error: &error) == .failed {
                            //MARK
                            //播放失败
                            return
                        }
                    }
                    
                    if !asset.isPlayable || asset.hasProtectedContent {
                        //MARK
                        //播放失败
                        return
                    }
                    
                    player.play()
                }
            }
            else {
                loadingState = true
            }

        }else{
            
        }
    }
}
extension PlayerView : PlayerViewToolBarDelegate {
    func playPauseAction(){
        if player.rate == 0.0 {
            player.rate = 1.0
        }else{
            player.rate = 0.0
        }
    }
    func fullSmallAction(){
        
    }
}
extension PlayerView{
    func initToolBar(){
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(toolBar)
        toolBar.delegate = self
        let constraintTop = NSLayoutConstraint(item: toolBar, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let constraintLeft = NSLayoutConstraint(item: toolBar, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let constraintRight = NSLayoutConstraint(item: toolBar, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        let constraintBottom = NSLayoutConstraint(item: toolBar, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        self.addConstraints([constraintTop,constraintLeft,constraintRight,constraintBottom])
    }
}

protocol PlayerDelegate: class {
    // MARK -- 待完善
    
}
