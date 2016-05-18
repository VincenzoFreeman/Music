//
//  QQLyricsCell.swift
//  QQMusics
//
//  Created by wenzhiji on 16/5/18.
//  Copyright © 2016年 Manager. All rights reserved.
//

import UIKit

class QQLyricsCell: UITableViewCell {
    
     @IBOutlet weak var lyricsLabel: QQLyricsLabel!
    var lyricsString:String = ""{
        didSet{
            lyricsLabel.text = lyricsString
        }
    }
    var progress:Double = 0{
        didSet{
            lyricsLabel.progress = progress
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()
        self.selectionStyle = .None
    }
    class func cellWithTableView(tableView : UITableView) -> QQLyricsCell{
        let cellID = "lyricsCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellID) as? QQLyricsCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("QQLyricsCell", owner: nil, options: nil).last as? QQLyricsCell
        }
        return cell!

    }
    
}
