//
//  ViewController.swift
//  Calculator
//
//  Created by 王卓 on 15/11/18.
//  Copyright © 2015年 BubbleTeam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    //判断用户是否正在输入
    var userIsInTheMiddleOfTypingANumber:Bool = false
    //通过建立一个CalculatorBrain的实例访问Model
    var brain = CalculatorBrain()
    //用于响应所有数字按钮点击的动作，通过参数判断
    @IBAction func appendDigit(sender: UIButton) {
         let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            display.text! += digit
        }else{
            display.text = digit
            userIsInTheMiddleOfTypingANumber=true
        }
    }
    //enter键的响应
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        //如果栈可求值，将值显示出来
        if let result  = brain.pushOperand(displayValue){
            displayValue = result
        }else{
            displayValue = 0
        }
    }
    //计算属性displayValue
    var displayValue:Double{
        get{
            //值为显示的内容的Double值
            return (NSNumberFormatter().numberFromString(display.text!)!.doubleValue)
        }
        set{
            //数字改变更新显示的内容
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    //操作符的点击事件
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber{
            enter()
        }
        //将操作符入栈
        if let result  = brain.performOperation(operation){
            displayValue = result
        }else{
            displayValue = 0
        }
        
    }
}

