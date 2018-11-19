//
//  DataEntries.swift
//  BluetoothTest
//
//  Created by 沈文 on 2018/11/12.
//  Copyright © 2018年 Nicolas Nascimento. All rights reserved.
//

import Foundation

class DataEntries{
    private var limitLength :Int
    private var myDataEntries:[PointEntry] = [] {
        didSet{ //超出limitLength，就remove数组第一个，保持数组长度为limitLength
            print("About to change to \(self.myDataEntries.count)")
            if self.myDataEntries.count > limitLength-1 {
                self.myDataEntries.remove(at: self.myDataEntries.startIndex)
            }
        }
    }
    
    init(_ limitLength:Int){
        self.limitLength = limitLength
    }
    func addPointEntry(_ newPointEntry :PointEntry)  {
        self.myDataEntries.append(newPointEntry)
        
    }
    
    func showDataEntries() -> [PointEntry] {
        return self.myDataEntries
    }
    
}
