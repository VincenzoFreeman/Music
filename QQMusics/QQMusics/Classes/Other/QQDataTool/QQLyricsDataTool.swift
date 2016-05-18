//
//  QQLyricsDataTool.swift
//  QQMusics
//
//  Created by wenzhiji on 16/5/18.
//  Copyright © 2016年 Manager. All rights reserved.
//

import UIKit

class QQLyricsDataTool: NSObject {
    // 根据当前时间和模型数组获得对应的行号
    class func getRowLyricsModel(currentTime : NSTimeInterval, lyricsModels:[QQLyricsModel]) -> (row:Int,lyricsModel:QQLyricsModel){
        let count = lyricsModels.count
        for i in 0..<count {
            let lyricsModel = lyricsModels[i]
            if currentTime >= lyricsModel.beginTime && currentTime < lyricsModel.endTime{
                return (i, lyricsModel)
            }
        }
        return (0,QQLyricsModel())
    }
    class func getData(fileName : String?) ->[QQLyricsModel]  {
        
        guard let path = NSBundle.mainBundle().pathForResource(fileName, ofType: nil) else{
            return [QQLyricsModel]()
        }
        // 加载歌词内容
        var lyricsContent = ""
        do{
          lyricsContent = try String(contentsOfFile: path)
        }catch{
            print(error)
            return [QQLyricsModel]()
        }
        // 将字符串分成字符串组
        let lyricsStringRowArray = lyricsContent.componentsSeparatedByString("\n")
        // 创建模型数组
        var lyricsModels = [QQLyricsModel]()
        // 遍历数组,添加到模型数组
        for lyricsStringRow in lyricsStringRowArray{
            // 过滤没用的
            if lyricsStringRow.containsString("[ti:") || lyricsStringRow.containsString("[ar:") || lyricsStringRow.containsString("[al:"){
                continue
            }
            let lyricsModel = QQLyricsModel()
            lyricsModels.append(lyricsModel)
            // 2. 拿到的是不是, 才是真正的可以解析的字符串
            // [00:00.89]传奇
            // 2.1 处理垃圾数据
            // 00:00.89]传奇
            // 将[替换为空
            let resultString = lyricsStringRow.stringByReplacingOccurrencesOfString("[", withString: "")
            // 分割为time和内容
            let timeAndContents = resultString.componentsSeparatedByString("]")
            if timeAndContents.count == 2 {
                let time = timeAndContents[0]
                lyricsModel.beginTime = QQTimeFormatTool.getTimeInterval(time)
                lyricsModel.lyricsString = timeAndContents[1]
            }
            let count = lyricsModels.count
            for i in 0..<count {
                if i != count - 1{
                    lyricsModels[i].endTime = lyricsModels[i + 1].beginTime
                }
                
                
            }
        }
        return lyricsModels
    }
}
