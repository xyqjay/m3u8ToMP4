//
//  TestViewController.swift
//  m3u8ToMp4
//
//  Created by Jay on 16/1/22.
//  Copyright © 2016年 imooc. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func test(){
        var welcomeMessage: String
        welcomeMessage = "haha"
        print(welcomeMessage)
        
        let π = 3.14159
        let 你好 = "你好世界"
        let 🐶🐮 = "dogcow"
        
        print("The current values of are \(🐶🐮) \(你好) \(π)")

        
//        var surveyAnswer: String?
        // surveyAnswer 被自动设置为 nil
        
        if let firstNumber = Int("4"), let secondNumber = Int("42"), firstNumber < secondNumber {
            print("\(firstNumber) < \(secondNumber)")
        }
        // prints "4 < 42"
    
        if #available(iOS 7, OSX 10.10, *) {
            // 在 iOS 使用 iOS 9 的 API, 在 OS X 使用 OS X v10.10 的 API
        } else {
            // 使用先前版本的 iOS 和 OS X 的 API
        }
        
        let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
        
        
        func backwards(_ s1: String, s2: String) -> Bool {
            return s1 > s2
        }
        var reversed = names.sorted(by: backwards)
        // reversed 为 ["Ewa", "Daniella", "Chris", "Barry", "Alex"]
        
        reversed = names.sorted(by: { (s1: String, s2: String) -> Bool in
            return s1 > s2
        })
//            {
//        
//        }
        
//        闭包表达式语法有如下一般形式：
//            
//            { (parameters) -> returnType in
//                statements
//        }
//        由于这个闭包的函数体部分如此短，以至于可以将其改写成一行代码：
        
        reversed = names.sorted( by: { (s1: String, s2: String) -> Bool in return s1 > s2 } )
        
//        根据上下文推断类型（Inferring Type From Context）
        reversed = names.sorted( by: { s1, s2 in return s1 > s2 } )
//        单表达式闭包隐式返回（Implicit Return From Single-Expression Clossures）
        reversed = names.sorted( by: { s1, s2 in s1 > s2 } )
        
//        参数名称缩写（Shorthand Argument Names）
        reversed = names.sorted( by: { $0 > $1 } )
//运算符函数（Operator Functions）
        reversed = names.sorted(by: >)

//        在闭包表达式语法一节中作为sort(_:)方法参数的字符串排序闭包可以改写为：
        reversed = names.sorted() { $0 > $1 }

    }
    
    func someFunctionThatTakesAClosure(_ closure: () -> Void) {
        // 函数体部分
    }
    
    // 以下是不使用尾随闭包进行函数调用
//    someFunctionThatTakesAClosure({
//    // 闭包主体部分
//    })
    
    // 以下是使用尾随闭包进行函数调用
//    someFunctionThatTakesAClosure() {
//    // 闭包主体部分
//    }
    
    //囧need study swift 3.0
//    func testMap(){
//        let digitNames = [
//            0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
//            5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
//        ]
//        let numbers = [16, 58, 510]
//        
//        let strings = numbers.map {
//            (number) -> String in
//            var output = ""
//            while number > 0 {
//                output = digitNames[number % 10]! + output
//                number /= 10
//            }
//            return output
//        }
//        // strings 常量被推断为字符串类型数组，即 [String]
//        // 其值为 ["OneSix", "FiveEight", "FiveOneZero"]
//    }
}
