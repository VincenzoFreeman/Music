//
//  QQDetailViewController.swift
//  QQMusics
//
//  Created by wenzhiji on 16/5/16.
//  Copyright © 2016年 Manager. All rights reserved.
//

import UIKit
// MARK:- 存放属性
class QQDetailViewController: UIViewController {
    // 背景图片
    @IBOutlet weak var backgroundImageView: UIImageView!
    // 歌手
    @IBOutlet weak var singerNameLabel: UILabel!
    // 歌名
    @IBOutlet weak var SongNameLabel: UILabel!
    //  歌词背景视图(用来做动画)
    @IBOutlet weak var lyricsBackView: UIScrollView!
       // 总时长
    @IBOutlet weak var totalTimeLabel: UILabel!
    // 播放暂停按钮
    @IBOutlet weak var playOrPause: UIButton!
//    @IBOutlet weak var lyricsBackImageView: UIImageView!
    //  专辑图片
    @IBOutlet weak var foreImageView: UIImageView!

    
    // 歌词
    @IBOutlet weak var lyricsLabel: UILabel!
    // 已经播放时长
    @IBOutlet weak var costTimeLabel: UILabel!
    // 进度条
    @IBOutlet weak var progressSlider: UISlider!
    // 歌词视图
    var lyricsView : UIView?
    var timer: NSTimer?
    
    
}
// MARK:- 逻辑处理
extension QQDetailViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnce()
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setUpFrame()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addTime()
        setUpDataOnce()
    }
    @IBAction func back() {
        navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func playOrPause(sender: UIButton) {
        sender.selected = !sender.selected
        if sender.selected{
            QQMusicOperationTool.shareInstance.playCurrentMusic()
        }else{
            QQMusicOperationTool.shareInstance.pauseCurrentMusic()
        }
    }
    @IBAction func nextMusic() {
        QQMusicOperationTool.shareInstance.nextMusic()
        setUpDataOnce()
    }

    @IBAction func preMusic() {
        QQMusicOperationTool.shareInstance.preMusic()
        setUpDataOnce()
    }
}
// MARK:- 数据展示
extension QQDetailViewController{
    // 获取最新数据
    func setUpDataOnce() -> () {
        let musicMessageModel = QQMusicOperationTool.shareInstance.getNowMessageModel()
        // 背景图片
        let imageName = musicMessageModel.musicModels?.icon ?? ""
        backgroundImageView.image = UIImage(named: imageName)
        // 歌手
        singerNameLabel.text = musicMessageModel.musicModels?.singer
        // 歌名
        SongNameLabel.text = musicMessageModel.musicModels?.name
        // 总时长
        totalTimeLabel.text = String(musicMessageModel.totalTime)
      
        //    @IBOutlet weak var lyricsBackImageView: UIImageView!
        //  专辑图片
        
        foreImageView.image = UIImage(named: imageName)
    }
    func setUpDataTimes() -> () {
        let musicMessageModel = QQMusicOperationTool.shareInstance.getNowMessageModel()
        // 已经播放时长
        costTimeLabel.text = "\(musicMessageModel.costTime)"
        // 进度条
        progressSlider.value = Float(musicMessageModel.costTime / musicMessageModel.totalTime)
    }
    func addTime() -> () {
        timer = NSTimer(timeInterval: 1, target: self, selector: #selector(setUpDataTimes), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
    }
    func removeTimer() -> () {
        timer?.invalidate()
        timer = nil
    }
}
// MARK:- 界面处理
extension QQDetailViewController{
    // 只需设置一次的
    func setupOnce() -> () {
        addLyricsView()
    }
    // 需要设置多次的
    func setUpFrame() -> () {
        setUpForeImageView()
        setUpLyricsViewFrame()
    }
    func setUpSlider() -> () {
        progressSlider.setThumbImage(UIImage(named: "player_slider_playback_thumb"), forState: .Normal)
    }
    // 设置歌词view的frame
    func setUpLyricsViewFrame()  {
        lyricsView?.frame = lyricsBackView.bounds
        lyricsView?.x = lyricsBackView.width
        lyricsBackView.contentSize = CGSizeMake(lyricsBackView.width * 2, 0)
    }
    func addLyricsView() -> () {
        // 创建歌词视图
        lyricsView = UIView()
        lyricsView?.backgroundColor = UIColor.clearColor()
        lyricsBackView.addSubview(lyricsView!)
        // 滚动逻辑
        lyricsBackView.pagingEnabled = true
        lyricsBackView.delegate = self
        lyricsBackView.showsHorizontalScrollIndicator = false
    }
    // 设置圆角图片
    func setUpForeImageView() -> () {
        foreImageView.layer.cornerRadius = foreImageView.width * 0.5
        foreImageView.layer.masksToBounds = true
    }
    // 设置状态栏
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
// MARK:- 动画处理
extension QQDetailViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // 隐藏除歌词以外的控件
        let alpha = 1 - scrollView.contentOffset.x / scrollView.width
        foreImageView.alpha = alpha
        lyricsLabel.alpha = alpha
    }
}