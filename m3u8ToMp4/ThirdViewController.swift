//
//  ThirdViewController.swift
//  m3u8ToMp4
//
//  Created by Jay on 16/1/28.
//  Copyright © 2016年 imooc. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var startServerButton: UIButton!

    let localServer = LocalServer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ThirdViewController {
    @IBAction func onClickStartServerButton(){
        localServer.startHttpServer()
    }
    @IBAction func onClickPlayVideoButton(){
//        let url = NSURL(string: "http://127.0.0.1:8888/-xmMKEjZjmk/index.m3u8")
//        let url = NSURL(string: "http://127.0.0.1:8888/index.m3u8")
//        let url = NSURL(string: "http://127.0.0.1:8888/-xmMKEjZjmk/index2.m3u8")
        let url = URL(string: "http://127.0.0.1:8888/index2.m3u8")
//        var resourcePath = NSBundle.mainBundle().pathForResource("-xmMKEjZjmk", ofType: nil)
//        resourcePath = resourcePath! + "/index2.m3u8"
//        let url = NSURL.fileURLWithPath(resourcePath!)
        print(url!.absoluteString)
        
        playerView.playVideoWithURL(url!)
    }

}
