//
//  PlayerViewToolBar.swift
//  m3u8ToMp4
//
//  Created by Jay on 16/1/27.
//  Copyright © 2016年 imooc. All rights reserved.
//

import UIKit
import SwiftRichString

class PlayerViewToolBar: UIView {
    @IBOutlet weak var bottomBar: UIView!
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var fullSmallButton: UIButton!
    @IBOutlet weak var timeTabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    weak var delegate: PlayerViewToolBarDelegate?
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        
        
    }
    
    override func awakeFromNib() {
        slider.setThumbImage(UIImage(named: "thumbImage"), for: UIControl.State())
    }
    override func didMoveToSuperview() {
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
        //            self.hideBar()
        //        }
    }
}
extension PlayerViewToolBar{
    func isPlaying(_ value:Bool){
        if value {
            playPauseButton.setTitle("暂停", for: UIControl.State())
        }else{
            playPauseButton.setTitle("播放", for: UIControl.State())
        }
    }
    func currentValue(_ value: Float){
        slider.value = value
    }
    func updateTimelabel(_ currentTime:Double,totalTime:Double){
//        print("\(currentTime)    \(totalTime)")
        let currentTimeString = currentTime.secondsDescription()
        let totalTimeString = totalTime.secondsDescription()
        
        let attribute = NSMutableAttributedString()
        
        let style1 = Style {
            $0.font = UIFont.systemFont(ofSize: 11)
            $0.color = UIColor(red: 153, green: 153, blue: 153, alpha: 1)
        }
        
        attribute.append(currentTimeString.set(style: style1))
        
        let style2 = Style {
            $0.font = UIFont.systemFont(ofSize: 11)
            $0.color = UIColor.black
        }
        
        let string = " / " + totalTimeString
        
        attribute.append(string.set(style: style2))

        timeTabel.attributedText = attribute
    }
    func loadedProgress(_ value: Float){
        
    }
    
}
extension Double{
    func secondsDescription()->String{
        // MARK 这里精度的问题可能会跳来跳去。后期再处理
        if self.isNaN {
            return ""
        }
        let minute = Int(self/60)
        let second = Int(self.truncatingRemainder(dividingBy: 60))
        var string1 = ""
        var string2 = ""
        if minute < 10 {
            string1 = "0" + "\(minute)"
        }else{
            string1 = "\(minute)"
        }
        if second < 10 {
            string2 = "0" + "\(second)"
        }else{
            string2 = "\(second)"
        }
        let string =  string1 + ":" + string2
        return string
    }
}
extension PlayerViewToolBar{
//    func
}
extension PlayerViewToolBar{
    func hideBar(){
        UIView.animate(withDuration: 0.35, animations: { () -> Void in
            self.bottomBar.alpha = 0.0
            }, completion: { (result) -> Void in
                //
        }) 
    }
    func showBar(){
        UIView.animate(withDuration: 0.35, animations: { () -> Void in
            self.bottomBar.alpha = 1.0
            
        }) 
    }
}
extension PlayerViewToolBar{
    @IBAction func onClickPlayPauseButton(){
        delegate?.playPauseAction()
    }
    
    @IBAction func onClickFullSmallButton(){
        print("暂不支持全屏切换")
    }
    
    @IBAction func taped(){
        if bottomBar.alpha == 1.0 {
            hideBar()
        }else{
            showBar()
        }
    }
}

protocol PlayerViewToolBarDelegate: class {
    // Action
    func playPauseAction()
    func fullSmallAction()
    
}
