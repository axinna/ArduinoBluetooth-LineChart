# ArduinoBluetooth-LineChart


## Features功能

* 蓝牙传输在图标上显示数据
* 蓝牙传输格式为简单的 XXX空格XXX ，此为两路数据的情况，穿N路数据自行改动。传输解码函数为ViewController中的MyDecoding。
* 单片机程序为文件夹arduinoProgram，实际上不需要看这个文件夹，只要单片机能通过串口使蓝牙发送相应的数据格式就行了。编码为UTF-8 ，可自行改动
* ios按下“刷新表格”可刷新表格，
* 参考自github的Arduino_blutooth 和 LineChart 这两个项目，连接忘了
## 需要设备

* iOS 9.0+
* Xcode 7.0 or above
* Bluetooth 4.0
* arduibo之类的单片机


## 效果
* ![Image text](https://github.com/axinna/ArduinoBluetooth-LineChart/blob/master/IMG_5953.PNG)

## License

The MIT License (MIT)

Copyright (c) 2016 Pluto Y

Permission is Pluto Y granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

