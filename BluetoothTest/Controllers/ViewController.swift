//
//  ViewController.swift
//  BluetoothTest
//
//  Created by Nicolas Nascimento on 15/12/17.
//  Copyright © 2017 Nicolas Nascimento. All rights reserved.
//
//参考自github LineChart-master和ArduinoBluetooth



import UIKit
import CoreBluetooth

final class ViewController: UIViewController {
    // MARK: - Private Properties
    private var communicator: ArduinoCommunicator!
    private var loadingComponent: LoadingComponent!
    var wenduDataEntries  = DataEntries.init(300) //初始化300为图表一次所能x显示的最多点数
    var xinlvDataEntries  = DataEntries.init(50)
    var myTestKalmanFilter = MyKalmanFilter.init(0.0015,0.005, 550, 1)
    
    @IBOutlet weak var testTextView: UITextView!
    @IBOutlet weak var wenduLineChart: LineChart!
    @IBOutlet weak var xinlvLineChart: LineChart!
    @IBOutlet weak var wenduDataText: UITextField!
    @IBOutlet weak var fixedWenduDataText: UITextField!
    @IBOutlet weak var xinlvDataText: UITextField!
    
    // MARK: - View Controller Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadingComponent = LoadingComponent()//没有收到蓝牙信号就出现这个s组件
        
        self.communicator = ArduinoCommunicator(delegate: self)
        
        self.loadingComponent.addLoadingIndicator(to: self.view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wenduLineChart.dataEntries = wenduDataEntries.showDataEntries()
        wenduLineChart.isCurved = false //可设置曲线（true）还是折现
        wenduLineChart.lineGap  = 20 //可设置点距
        
        xinlvLineChart.dataEntries = xinlvDataEntries.showDataEntries()
        xinlvLineChart.isCurved = false
        xinlvLineChart.lineGap  = 10
    }
    
    //MARK:-action


    @IBAction func testButton(_ sender: Any) {
        print("did press button！")
        wenduLineChart.dataEntries = self.wenduDataEntries.showDataEntries()
        wenduLineChart.isCurved = false
        xinlvLineChart.dataEntries = self.xinlvDataEntries.showDataEntries()
        xinlvLineChart.isCurved = false
    }
    
    
    //蓝牙传输解码
    func myDecodding(_ data : Data ,_ typOfSignal:String) -> Double? {
        if let strTemp = String(data: data, encoding: .utf8){
            let pos1 = strTemp.positionOf(sub: " ")
        
            switch typOfSignal{
            case  "wendu":
                return Double(strTemp[0..<pos1])
            case "xinlv":
                return Double(strTemp[(pos1+1)..<(strTemp.count)])
            default:
                print("ViewController-->myDecodding:不存在这个信号类型")
                return nil
        }
        }else{
            return nil
        }
        //strTemp.distance(from: strTemp.startIndex, to: strTemp.endIndex)
    }
    
}

extension ViewController: ArduinoCommunicatorDelegate {
    func communicatorDidConnect(_ communicator: ArduinoCommunicator) {
        self.loadingComponent.removeLoadingIndicators(from: self.view)
    }
    func communicator(_ communicator: ArduinoCommunicator, didRead data: Data) {
        print(#function)
        print(String(data: data, encoding: .utf8) ?? "nil")
        
        // get time
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        let date = Date()
        
        if let wenduData = myDecodding(data,"wendu"),wenduData < 45,wenduData > 15 {
            wenduDataEntries.addPointEntry(PointEntry(value: wenduData, label: formatter.string(from: date)))
            
            wenduDataText.text = "\(String(format: "%.2f", wenduData))℃"
            fixedWenduDataText.text = "\(String(format: "%.2f", wenduData*0.4089+21.9706))℃"//经过回归矫正后的温度
        }
        if let xinlvData = myDecodding(data,"xinlv"),xinlvData < 1024 {
            
            xinlvDataEntries.addPointEntry(PointEntry(value: xinlvData, label: formatter.string(from: date)))
                xinlvDataText.text = "\(xinlvData)"
        }
        
        testTextView.text = "当前回传的测试值："
        testTextView.text += String(data: data, encoding: .utf8)!
        
        
        }
    
    
    
    func communicator(_ communicator: ArduinoCommunicator, didWrite data: Data) {
        print(#function)
        print(String(data: data, encoding: .utf8)!)
    }
}

extension String {
    //返回第一次出现的指定子字符串在此字符串中的索引
    //（如果backwards参数设置为true，则返回最后出现的位置）
    func positionOf(sub:String, backwards:Bool = false)->Int {
        var pos = -1
        if let range = range(of:sub, options: backwards ? .backwards : .literal ) {
            if !range.isEmpty {
                pos = self.distance(from:startIndex, to:range.lowerBound)
            }
        }
        return pos
    }
    /// 使用下标截取字符串 例: "示例字符串"[0..<2] 结果是 "示例"
    subscript (r: Range<Int>) -> String {
        get {
            if (r.lowerBound > count) || (r.upperBound > count) { return "截取超出范围" }
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[startIndex..<endIndex])
        }
    }
    

}

extension Collection where Element: Equatable {
    func indexDistance(of element: Element) -> Int? {
        guard let index = index(of: element) else { return nil }
        return distance(from: startIndex, to: index)
    }
}
