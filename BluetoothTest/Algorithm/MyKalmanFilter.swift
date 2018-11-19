//
//  MyKalmanFilter.swift
//  BluetoothTest
//
//  Created by 沈文 on 2018/11/3.
//  Copyright © 2018年 Nicolas Nascimento. All rights reserved.
//

import Foundation

class MyKalmanFilter{
    private var Q = 0.0
    private var R = 0.0
    private var X = 0.0//
    private var P = 0.0
    
    init(_ Q : Double , _ R: Double , _ X0: Double , _ P0: Double) {
        self.Q = Q
        self.R = R
        self.X = X0
        self.P = P0
    }
    
    func kalmanFilter(_ observation:Double) -> Double  {
        let K = self.P / (self.P + self.R)
        self.X = Double(self.X) + K * Double((observation - self.X))//
        self.P = (1 - K) * self.P + self.Q
        
        return self.X
    }
    
}
