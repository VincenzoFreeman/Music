//
//  QQListCell.swift
//  QQMusics
//
//  Created by wenzhiji on 16/5/16.
//  Copyright © 2016年 Manager. All rights reserved.
//

import UIKit
enum AnimationType {
    case Transltion
    case Rotation
}
class QQListCell: UITableViewCell {
    // MARK:- 属性
    @IBOutlet weak var singerNameLabel: UILabel!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    var musicModel:QQMusicModel?{
        didSet{
            if musicModel?.icon != nil{
                iconImageView.image = UIImage(named: (musicModel?.icon)!)
            }
            singerNameLabel.text = musicModel?.singer
            songNameLabel.text = musicModel?.name
        }
    }
    // MARK:- 提供快速创建cell
    class func cellWithTableView(tableView:UITableView) -> QQListCell {
        let cellID = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellID) as? QQListCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("QQListCell", owner: nil, options: nil).last as? QQListCell
        }
        return cell!
    }
    // MARK:- 动画
    func beginAnimation(type : AnimationType)  {
        switch type {
        case .Rotation: // 添加旋转动画
            // 移除之前的动画
            self.layer.removeAnimationForKey("rotation")
            let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            // 旋转角度
            animation.values = [M_PI * 0.5, 0]
            // 动画时间
            animation.duration = 0.5
            self.layer.addAnimation(animation, forKey: "rotation")
            
            
        case .Transltion:
            self.layer.removeAnimationForKey("translation")
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            // 移动距离
            animation.values = [50, 0]
            animation.duration = 0.5
            self.layer.addAnimation(animation, forKey: "translation")
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.layer.cornerRadius = iconImageView.width * 0.5
        iconImageView.layer.masksToBounds = true
        self.backgroundColor = UIColor.clearColor()
        // 取消选中cell样式
        self.selectionStyle = .None
    }
    // 取消高亮
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
}
