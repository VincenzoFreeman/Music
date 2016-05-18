//
//  QQListTViewController.swift
//  QQMusics
//
//  Created by wenzhiji on 16/5/16.
//  Copyright © 2016年 Manager. All rights reserved.
//

import UIKit

class QQListTViewController: UITableViewController {
    var musicModels : [QQMusicModel] = [QQMusicModel](){
            didSet{
                tableView.reloadData()
        
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpInit()
        // 加载数据
        QQMusicDataTool.getMusicList { (musics) in
            self.musicModels = musics
            QQMusicOperationTool.shareInstance.musicModelLists = musics
        }
    }




    

}
// MARK:- 显示数据
extension QQListTViewController{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicModels.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = QQListCell.cellWithTableView(tableView)
        cell.musicModel = musicModels[indexPath.row]
        return cell
    }
    // cell即将显示时调用
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let musicCell = cell as! QQListCell
        musicCell.beginAnimation(AnimationType.Rotation)
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 播放音乐
        let musicModel = musicModels[indexPath.row]
        QQMusicOperationTool.shareInstance.playMusic(musicModel)
        // 调到详情界面
        performSegueWithIdentifier("listToDetail", sender: nil)
    }
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        // 取出所有cell的indexPath
        guard let indexPaths = tableView.indexPathsForVisibleRows else {
            return
        }
        // 计算中间的cell
        let first = indexPaths.first?.row ?? 0
        let last = indexPaths.last?.row ?? 0
        let middle = Int(Float(first + last) * 0.5)
        for indexPath in indexPaths{
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            // 取决对值
            cell?.x = CGFloat(abs((indexPath.row - middle) * 15))
        }
    }
}
// MARK:- 界面搭建
extension QQListTViewController{
    func setUpInit() {
        setUpTableView()
        setUpNavigationBar()
    }
    private func setUpNavigationBar() -> () {
        navigationController?.navigationBarHidden = true
    }
    private func setUpTableView()  {
        let backImageView = UIImageView(image: UIImage(named: "QQListBack"))
        tableView.backgroundView = backImageView
        tableView.rowHeight = 60
        // 取消cell分割线
        tableView.separatorStyle = .None

    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

}