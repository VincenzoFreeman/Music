//
//  QQLyricsLabel.swift
//  QQMusics
//
//  Created by wenzhiji on 16/5/18.
//  Copyright © 2016年 Manager. All rights reserved.
//

import UIKit

class QQLyricsLabel: UILabel {

   
    var progress: Double = 0.0 {
        didSet{
            setNeedsDisplay()
        }
    }
    override func drawRect(rect: CGRect) {
//        super.drawTextInRect(rect)
        super.drawRect(rect)
        // 设置填充色
        UIColor.greenColor().set()
        
        let fillRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width * CGFloat(progress), rect.size.height)
        
        UIRectFillUsingBlendMode(fillRect, .SourceIn)
    }
    

}
