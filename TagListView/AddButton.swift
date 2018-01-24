//
//  CloseButton.swift
//  TagListViewDemo
//
//  Created by Benjamin Wu on 2/11/16.
//  Copyright © 2016 Ela. All rights reserved.
//

import UIKit

internal class AddButton: UIButton {
    
    var iconSize: CGFloat = 10
    var lineWidth: CGFloat = 1
    var lineColor: UIColor = UIColor.white.withAlphaComponent(0.54)
    
    weak var tagView: TagView?
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        
        path.lineWidth = lineWidth
        path.lineCapStyle = .round
        
        let iconFrame = CGRect(
            x: (rect.width - iconSize) / 2.0,
            y: (rect.height - iconSize) / 2.0,
            width: iconSize,
            height: iconSize
        )
        
        path.move(to: CGPoint(x: iconFrame.minX, y: iconFrame.midY))
        path.addLine(to: CGPoint(x: iconFrame.maxX, y: iconFrame.midY))
        lineColor.setStroke()
        
        path.stroke()
        
        let otherPath = UIBezierPath()
        
        otherPath.lineWidth = lineWidth
        otherPath.lineCapStyle = .round
        
        otherPath.move(to: CGPoint(x: iconFrame.midX, y: iconFrame.minY))
        otherPath.addLine(to: CGPoint(x: iconFrame.midX, y: iconFrame.maxY))
        lineColor.setStroke()
        
        otherPath.stroke()
    }
    
}

