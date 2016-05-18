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
    @IBOutlet weak var lyricsLabel: QQLyricsLabel!
    // 已经播放时长
    @IBOutlet weak var costTimeLabel: UILabel!
    // 进度条
    @IBOutlet weak var progressSlider: UISlider!
    // 歌词视图
    var timer: NSTimer?
    var displayLink : CADisplayLink?
    
    lazy var lyricsVC : QQLyricsTViewController = {
        let lyricsVC = QQLyricsTViewController()
        return lyricsVC
    }()
    
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
        addDisplayLink()
    }
    @IBAction func back() {
        navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func playOrPause(sender: UIButton) {
        sender.selected = !sender.selected
        if sender.selected{
            QQMusicOperationTool.shareInstance.playCurrentMusic()
            resumeRotationAimation()
        }else{
            QQMusicOperationTool.shareInstance.pauseCurrentMusic()
            pauseRatationAnimation()
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
        let musicMessageModel = QQMusicOperationTool.shareInstance.getNewMessageModel()
        // 背景图片
        let imageName = musicMessageModel.musicModels?.icon ?? ""
        foreImageView.image = UIImage(named: imageName)
        backgroundImageView.image = UIImage(named: imageName)
        // 歌手
        singerNameLabel.text = musicMessageModel.musicModels?.singer
        // 歌名
        SongNameLabel.text = musicMessageModel.musicModels?.name
        // 总时长
        totalTimeLabel.text = QQTimeFormatTool.getTimeFormat(musicMessageModel.totalTime)
      
        //    @IBOutlet weak var lyricsBackImageView: UIImageView!
        //  专辑图片
        // 获取歌词数据
        let lyricsModels = QQLyricsDataTool.getData(musicMessageModel.musicModels?.lrcname)
        
        // 交给控制器展示歌词
        lyricsVC.dataSource = lyricsModels
        addRotationAnimation()
        // 判断是否在播放
        if musicMessageModel.isPlaying{
            resumeRotationAimation()
        }else{
            pauseRatationAnimation()
        }
    }
    // 更新歌词
    func updateLytics() -> () {
        let musicMessageModel = QQMusicOperationTool.shareInstance.getNewMessageModel()
        // 获取到需要滚动到的行号
        let rowAndLyricsModel = QQLyricsDataTool.getRowLyricsModel(musicMessageModel.costTime, lyricsModels: lyricsVC.dataSource)
        lyricsVC.scrollRow = rowAndLyricsModel.row
        let lyricsModel = rowAndLyricsModel.lyricsModel
        lyricsLabel.text = lyricsModel.lyricsString
        // 更新歌词进度(当前时间-开始时间)/(结束时间-开始时间)
        let value = (musicMessageModel.costTime - lyricsModel.beginTime) / (lyricsModel.endTime - lyricsModel.beginTime)
//        print(value)
        lyricsLabel.progress = value
        lyricsVC.progress = value
    }
    // 多次刷新数据
    func setUpDataTimes() -> () {
        let musicMessageModel = QQMusicOperationTool.shareInstance.getNewMessageModel()
        // 已经播放时长
        costTimeLabel.text = QQTimeFormatTool.getTimeFormat(musicMessageModel.costTime)
        // 进度条
        progressSlider.value = Float(musicMessageModel.costTime / musicMessageModel.totalTime)
    }
    // 添加定时器
    func addTime() -> () {
        timer = NSTimer(timeInterval: 1, target: self, selector: #selector(setUpDataTimes), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
    }
    // 移除定时器
    func removeTimer() -> () {
        timer?.invalidate()
        timer = nil
    }
    func addDisplayLink() -> () {
        displayLink = CADisplayLink(target: self, selector: #selector(updateLytics))
        displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    func removeDisplayLink() -> () {
        displayLink?.invalidate()
        displayLink = nil
    }
}
// MARK:- 界面处理
extension QQDetailViewController{
    // 只需设置一次的
    func setupOnce() -> () {
        addLyricsView()
        setUpSlider()
    }

    // 需要设置多次的
    func setUpFrame() -> () {
        setUpForeImageView()
        setUpLyricsViewFrame()
    }
    func setUpSlider() -> () {
        // 设置进度条样式
        progressSlider.setThumbImage(UIImage(named: "player_slider_playback_thumb"), forState: .Normal)
    }
    // 设置歌词view的frame
    func setUpLyricsViewFrame()  {
        lyricsVC.tableView.frame = lyricsBackView.bounds
        lyricsVC.tableView.x = lyricsBackView.width
        lyricsBackView.contentSize = CGSizeMake(lyricsBackView.width * 2, 0)
    }
    // 添加显示歌词的view
    func addLyricsView() -> () {
        // 创建歌词视图
       
        lyricsVC.tableView.backgroundColor = UIColor.clearColor()
        lyricsBackView.addSubview(lyricsVC.tableView)
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
    // 添加专辑动画
    func addRotationAnimation() -> () {
        foreImageView.layer.removeAnimationForKey("rotation")
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        // 旋转角度(前一个数组参数代码坐旋转)
        animation.values = [0,M_PI * 2]
        // 动画时间
        animation.duration = 30
        animation.repeatCount = MAXFLOAT
        // 播放完之后不移除
        animation.removedOnCompletion = false
        foreImageView.layer.addAnimation(animation, forKey: "rotation")
    }
    // 继续播放
    func resumeRotationAimation() -> () {
        foreImageView.layer.resumeAnimate()
    }
    // 暂停播放
    func pauseRatationAnimation() -> () {
        foreImageView.layer.pauseAnimate()
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // 隐藏除歌词以外的控件
        let alpha = 1 - scrollView.contentOffset.x / scrollView.width
        foreImageView.alpha = alpha
        lyricsLabel.alpha = alpha
    }
}