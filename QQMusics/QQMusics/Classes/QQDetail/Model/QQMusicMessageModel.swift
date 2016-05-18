//
//  QQMusicMessageModel.swift
//  QQMusics
//
//  Created by wenzhiji on 16/5/17.
//  Copyright © 2016年 Manager. All rights reserved.
//

import UIKit

class QQMusicMessageModel: NSObject {
    var musicModels : QQMusicModel?
    // 当前时间
    var costTime : NSTimeInterval = 0
    // 总时长
    var totalTime : NSTimeInterval = 0
    // 是否在播放
    var isPlaying : Bool = false
    
}
