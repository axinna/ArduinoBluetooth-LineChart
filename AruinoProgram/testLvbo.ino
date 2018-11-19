#include <TimerOne.h>//加载定时器库
#include <Wire.h>
#include <Adafruit_MLX90614.h>//温度传感器库

Adafruit_MLX90614 mlx = Adafruit_MLX90614();
String str;

//以下变量计算心率用的 没成功 可不看
int time = 10000;//10ms
int HRSampleTime = 5 ;//s
const int HRArrLength = HRSampleTime * 100;//HRSampleTime / time * 1000000
int HRArr[500] ;//[HRArrLength]
int HRNum = 0;
int HeartRate = 2000;
int Filter_Value;
int PulseSensorPurplePin = 0;
int Signal;
//kalman 参数
float _Q = 0.0011;
float _R = 0.025;
float _X = 510.0;
float _P = 1.0;

void setup() { //初始化
  Serial.begin(9600);       // 初始化串口通信
  Timer1.initialize(time); 
  Timer1.attachInterrupt(CalculateHeartRate);
  mlx.begin(); 
}
 
void loop() { //蓝牙通讯 串口发送 xxx空格xxx 的格式 即可发送数据 UTF-8编码
     str = String(mlx.readObjectTempC());
     str += " ";
     str += String(HeartRate); //HeartRate也可以是其他数据
     Serial.print(str);
    delay(2000);
}
 
void CalculateHeartRate(void){ //定时器 每隔一定时间取一次PPG信号
    Signal = analogRead(PulseSensorPurplePin);
    int KalSignal = kalmanFilter(Signal);
    HRArr[HRNum] = KalSignal;
    //Serial.println(HRArr[HRNum]); // 串口输出
    HRNum++;//一下计算心率失败 可不看
    if(HRNum == HRArrLength){
      HRNum = 0;
      int HR = findPeaks(HRArr);
      HeartRate = int(HR * (60 / HRSampleTime));
      //Serial.println(HR);
    }
}

//kalman
int kalmanFilter(int newValue){
  float K = _P/(_P+_R);
  _X = _X + K * float(newValue - _X);
  _P = (1 - K) * _P + _Q;
  return int(_X);
}

// 可不看
int findPeaks(int *HRArr){
  int HR = 0;
  int HRflag = 0;
  int HRMax = 0;
  int HRMin = 1000;  
  int threshold = 0;
  int top = HRArr[0];
  int bottom = HRArr[0];
 
  int HRIndexthreshold = 10; 
  int HRIndex = -HRIndexthreshold;
  for(int i = 0;i < HRArrLength; i++){
    if(HRArr[i] > HRMax){
      HRMax = HRArr[i];
    }
    if(HRArr[i] < HRMin){
      HRMin = HRArr[i];
    }
  }
  
  threshold = int((HRMax - HRMin) * 0.5);

  for(int iIndex = 0;iIndex+1 < HRArrLength; iIndex++){
    if(HRArr[iIndex+1] >= HRArr[iIndex]){
      if(HRflag == 1){
        bottom = HRArr[iIndex];
      }
      HRflag = 0;
    }else{
      if(HRflag == 0){
         top = HRArr[iIndex];
         if((top - bottom) > threshold){
          HR++;
         }
      }
      HRflag = 1;
    }
  }
  return HR;
}  
  
