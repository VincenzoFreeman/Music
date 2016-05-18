//
//  QQMusicOperationTool.swift
//  QQMusics
//
//  Created by wenzhiji on 16/5/16.
//  Copyright © 2016年 Manager. All rights reserved.
//

import UIKit

class QQMusicOperationTool: NSObject {
    // 创建单例
    static let shareInstance = QQMusicOperationTool()
    // 记录当前正在播放的索引
    var index = 0{
        didSet{
            if index < 0{
                index = (musicModelLists?.count ?? 0) - 1
            }
            
            if index > (musicModelLists?.count ?? 0) - 1{
                index = 0
            }
        }
    }
    private var musicMessageModel : QQMusicMessageModel = QQMusicMessageModel()
    func getNowMessageModel() -> QQMusicMessageModel {
        // 给属性赋值
        musicMessageModel.musicModels = musicModelLists?[index]
        // 已经播放时间
        musicMessageModel.costTime = tool.player?.currentTime ?? 0
        // 总
        musicMessageModel.totalTime = tool.player?.duration ?? 0
        // 播放状态
        musicMessageModel.isPlaying = tool.player?.playing ?? false
        return musicMessageModel
    }
    var musicModelLists : [QQMusicModel]?
    let tool = QQMusicTool()
    func playMusic(musicModel : QQMusicModel)  {
        let fileName = musicModel.filename ?? ""
        tool.playMusic(fileName)
        if musicModelLists == nil {
            print("没有播放列表")
            return
        }
        index = (musicModelLists?.indexOf(musicModel))!
    }
    func playCurrentMusic() -> () {
        tool.resumeCurrentMusic()
    }
    func pauseCurrentMusic() -> () {
        tool.pauseCurrentMusic()
    }
    func preMusic() -> () {
        index -= 1
        if let tempList = musicModelLists{
            let musicModel = tempList[index]
            playMusic(musicModel)
        }

    }
    func nextMusic() -> () {
        index += 1
        if let tempList = musicModelLists{
            let musicModel = tempList[index]
            playMusic(musicModel)
        }
    }
}
