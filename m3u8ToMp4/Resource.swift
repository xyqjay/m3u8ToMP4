//
//  Resource.swift
//  m3u8ToMp4
//
//  Created by Jay on 16/1/26.
//  Copyright © 2016年 imooc. All rights reserved.
//

import Foundation
class Resource {
    class func document() -> String{
        let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentString = document[0]
        print(documentString)
        return documentString
    }

    class func resourceForTS() -> String{
        var string = ""
        let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentString = document[0]
        print(documentString)
//        let resource = documentString + "/6xvKVNFv9UI/index.m3u8"
        string = documentString + "/6xvKVNFv9UI"
        return string
    }
}
