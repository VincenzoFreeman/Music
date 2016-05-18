//
//  QQTimeFormatTool.swift
//  QQMusics
//
//  Created by wenzhiji on 16/5/18.
//  Copyright © 2016年 Manager. All rights reserved.
//

import UIKit

class QQTimeFormatTool: NSObject {
    class func getTimeFormat(time : NSTimeInterval ) -> String{
        
        return String(format: "%02d:%02d", Int(time / 60),Int(time % 60))
    }
    class func getTimeInterval(formatTime : String) -> NSTimeInterval {
        // 分解字符串
        let strings = formatTime.componentsSeparatedByString(":")
        if strings.count == 2 {
            let minute = NSTimeInterval(strings[0]) ?? 0
            let second = NSTimeInterval(strings[1]) ?? 0
            return minute * 60 + second
        }
        return 0
    }
}
