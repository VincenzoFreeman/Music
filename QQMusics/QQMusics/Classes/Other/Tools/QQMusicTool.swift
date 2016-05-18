//
//  QQMusicTool.swift
//  QQMusics
//
//  Created by wenzhiji on 16/5/16.
//  Copyright © 2016年 Manager. All rights reserved.
//

import UIKit
import AVFoundation
class QQMusicTool: NSObject {
    var player : AVAudioPlayer?
    override init() {
        super.init()
        // 获取音频会话
        let session = AVAudioSession.sharedInstance()
        do{
            // 设置音频会话类别
            try session.setCategory(AVAudioSessionCategoryPlayback)
            try session.setActive(true)
        }catch{
            print(error)
            return
        }
        
    }
    func playMusic(name : String) {
        // 创建播放器
        guard let url = NSBundle.mainBundle().URLForResource(name, withExtension: nil) else{
            return
        }
        // 判断是否播放同一首歌曲
        if url == player?.url{
            player?.play()
            return
        }
        do{
            player = try AVAudioPlayer(contentsOfURL: url)
        }catch{
            print(error)
            return
        }
        // 准备播放
        player?.prepareToPlay()
        // 开始播放
        player?.play()
        
    }
    func pauseCurrentMusic() -> () {
        player?.pause()
    }
    func resumeCurrentMusic() -> () {
        player?.play()
    }

}
