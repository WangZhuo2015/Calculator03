//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 王卓 on 15/11/21.
//  Copyright © 2015年 BubbleTeam. All rights reserved.
//

import Foundation
class CalculatorBrain{
    //CustomStringConvertible即原Printabel protocol
    private enum Op:CustomStringConvertible{
        //Swift语言中枚举可以绑定值
        case operand(Double)
        case UnaryOperation(String,Double->Double)
        case BinaryOperation(String,(Double,Double)->Double)
        //实现CustomStringConvertible中规定的方法
        var description:String{
        get {
            switch self{
            //通过let获得operand的值
            case .operand(let operand):
                return "\(operand)"
            //由于此处不关心函数的值、用下划线代替
            case .UnaryOperation(let symbol, _):
                return symbol
            case .BinaryOperation(let symbol, _):
                return symbol
            }
        }
    }

    }
    //存储所有操作数、操作符的栈
    private var opStack=[Op]()
    //已知操作符的Dictionary
    private var knowsOps = [String:Op]()
    //构造器,初始化已知的操作符
    init(){
        //TO DO:
        func learnOps(){}
        //＋放在此处有特殊的方法获得参数
        knowsOps["+"] = Op.BinaryOperation("+", +)
        //由于减法左右操作数不可交换，故通过尾挂闭包传参
        knowsOps["−"] = Op.BinaryOperation("−"){$1 - $0}
        knowsOps["×"] = Op.BinaryOperation("×", *)
        knowsOps["÷"] = Op.BinaryOperation("÷"){$1 / $0}
        //与+相同
        knowsOps["√"] = Op.UnaryOperation("√", sqrt)
    }
    /**
    递归对栈求值
    
    - parameter ops: 操作数、操作符栈
    
    - returns: 返回值为一个optional Double类型数据和余下的栈
    */
    private func evaluate(ops:[Op])->(result:Double?,remainingOps:[Op]){
        if !ops.isEmpty{
            var remainingOps = ops;
            //取栈顶元素
            let op = remainingOps.removeLast()
            //根据类型的不同进行不同的操作
            switch op {
            //操作数则返回
            case .operand(let operand):
                return (operand,remainingOps)
            //一元运算符,继续递归
            case .UnaryOperation(_, let operation):
                let operandEvaluate = evaluate(remainingOps)
                //从递归的结果中取出结果,可选绑定判断是否有值
                if let operand = operandEvaluate.result{
                    //返回
                    return (operation(operand),operandEvaluate.remainingOps)
                }
            //二元运算符,类似的操作
            case .BinaryOperation(_, let operation):
                let op1Evaluate = evaluate(remainingOps)
                if let operand1 = op1Evaluate.result{
                    let op2Evaluate = evaluate(op1Evaluate.remainingOps)
                    if let operand2 = op2Evaluate.result{
                        return (operation(operand1,operand2),op2Evaluate.remainingOps)
                    }
                }
            }
        }
        return(nil,ops)
    }
    //对栈求值
    func evaluate()->Double?{
        let (result,remainder) = evaluate(opStack)
        print("\(opStack) = \(result) + \(remainder) left over")
        return result
    }
    //将操作数入栈,返回递归求值的结果
    func pushOperand(operand:Double)->Double?{
        opStack.append(Op.operand(operand))
        return evaluate()
    }
    //将操作符入栈,返回递归求值的结果
    func performOperation(symbol:String)->Double?{
        if let operation = knowsOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
}