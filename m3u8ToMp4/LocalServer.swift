//
//  LocalServer.swift
//  m3u8ToMp4
//
//  Created by Jay on 16/1/28.
//  Copyright © 2016年 imooc. All rights reserved.
//

import Foundation

class LocalServer: HTTPServer {
//var ips = Dictionary()
    fileprivate var isInit = false
    
    required override init() {
        super.init()
        initNotifications()
        initHTTPServer()
        print("init")
    }
    
    func initNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(LocalServer.HTTPConnectionDidDie(_:)), name: NSNotification.Name(rawValue: HTTPConnectionDidDieNotification), object: nil)
    }
    
    func initHTTPServer(){
        // MARK 这里prot 写死的  资源地址写死的，可以根据需要修改。。。
        setPort(8888)
        setDocumentRoot(Bundle.main.path(forResource: "-xmMKEjZjmk", ofType: nil))
        setType("_http._tcp.")
        setConnectionClass(HTTPConnection.self)
        isInit = true
    }
    
    func startHttpServer(){
        if isInit && !isRunning() {
            do {
                try start()
            }catch {
                print("启动失败")
            }
        }
    }
    
    func stopHttpServer(){
        if isRunning() {
            stop()
        }
    }
}

extension LocalServer{
    @objc func HTTPConnectionDidDie(_ notification:Notification){
        
    }
}
