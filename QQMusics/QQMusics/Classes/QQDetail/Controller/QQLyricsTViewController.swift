//
//  QQLyricsTViewController.swift
//  QQMusics
//
//  Created by wenzhiji on 16/5/18.
//  Copyright © 2016年 Manager. All rights reserved.
//

import UIKit

class QQLyricsTViewController: UITableViewController {

    var dataSource : [QQLyricsModel] = [QQLyricsModel](){
        didSet{
            tableView.reloadData()
        }
    }
    var progress:Double = 0{
        didSet{
            // 获取正在播放的cell
            let indexPath = NSIndexPath(forRow: scrollRow, inSection: 0)
            let cell = tableView.cellForRowAtIndexPath(indexPath) as? QQLyricsCell
            cell?.progress = progress
        }
    }
    
    var scrollRow : Int = 0{
        didSet{
            // 防止重复滚动
            if  scrollRow != oldValue {
                tableView.reloadRowsAtIndexPaths(tableView.indexPathsForVisibleRows!, withRowAnimation: .Fade)
                let indexPath = NSIndexPath(forRow: scrollRow, inSection: 0)
                tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .None
        tableView.allowsSelection = true
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.contentInset = UIEdgeInsetsMake(tableView.width * 0.5, 0, tableView.width * 0.5, 0)
    }

  
    
  
}
// MARK:- 数据展示
extension QQLyricsTViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count ?? 0
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = QQLyricsCell.cellWithTableView(tableView)
        if indexPath.row == scrollRow {
            cell.progress = progress
        }else {
            cell.progress = 0
        }
        let lyrics = dataSource[indexPath.row]
        cell.lyricsString = lyrics.lyricsString
        return cell
        }

}
