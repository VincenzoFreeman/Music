//
//  QQMusicDataTool.swift
//  QQMusics
//
//  Created by wenzhiji on 16/5/16.
//  Copyright © 2016年 Manager. All rights reserved.
//

import UIKit

class QQMusicDataTool: NSObject {
    class func getMusicList(result:(musics:[QQMusicModel])->()) {
        guard let path = NSBundle.mainBundle().pathForResource("Musics.plist", ofType: nil) else {
            result(musics: [QQMusicModel]())
            return
        }
        
        // 加载内容
        guard let dictArray = NSArray(contentsOfFile: path) else {
            result(musics: [QQMusicModel]())
            return
        }
        // 遍历数组
        var resultModels = [QQMusicModel]()
        for dict in dictArray {
            let musicModel = QQMusicModel(dic: dict as! [String : AnyObject])
            resultModels.append(musicModel)
        }
        // 返回数组出去
        result(musics: resultModels + resultModels)
        
    }
}
