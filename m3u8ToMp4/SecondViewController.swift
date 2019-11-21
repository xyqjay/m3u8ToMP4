//
//  SecondViewController.swift
//  m3u8ToMp4
//
//  Created by Jay on 16/1/22.
//  Copyright © 2016年 imooc. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    @IBOutlet weak var playerView: PlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onClickPlay(){
        let bundle = Bundle.main
//        let resourcePath = bundle.pathForResource("112", ofType: "ts")
//        let resourcePath = bundle.pathForResource("welcome_2", ofType: "mp4")
//        let resourcePath = bundle.pathForResource("112", ofType: "avi")
//        let resourcePath = bundle.pathForResource("112", ofType: "mp4")
        let resourcePath = bundle.path(forResource: "fileSequence0", ofType: "ts")

        let url = URL(fileURLWithPath: resourcePath!)
//        let url = NSURL(string: "http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8")
        print(url.absoluteString)

        playerView.playVideoWithURL(url)
    }
    
    @IBAction func onClickPlayDocumentResource(){
        let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentString = document[0]
        print(documentString)
        let resource = documentString + "/6xvKVNFv9UI/index.m3u8"
        let url = URL(fileURLWithPath: resource)
        playerView.playVideoWithURL(url)
        print(url.absoluteString)
       var string =  NSString()
        string = string.appendingPathComponent("6xvKVNFv9UI") as NSString
    
        do {
            string = try NSString(contentsOfFile: resource, encoding: String.Encoding.utf8.rawValue) as String as String as NSString
        } catch {
            print("Unable to register webserver \(error)")
        }
        
        print(string)
    }
}

extension SecondViewController{
    @IBAction func onClickPlayFirstButton(){
        let string = Bundle.main.path(forResource: "1", ofType: "mp4")

        let url = URL(fileURLWithPath: string!)
        playerView.playVideoWithURL(url)

    }
    @IBAction func onClickAddItem(){
        let string = Bundle.main.path(forResource: "2", ofType: "mp4")
        let url = URL(fileURLWithPath: string!)
        playerView.addItem(url)

    }
}
