//
//  BarGraphView.swift
//  SmartTaskManager
//
//  Created by CDMStudent on 3/17/25.
//

import UIKit

class BarGraphView: UIView {
        
        var highPriorityCount: CGFloat = 0
        var mediumPriorityCount: CGFloat = 0
        var lowPriorityCount: CGFloat = 0
        
        override func draw(_ rect: CGRect) {
            guard let context = UIGraphicsGetCurrentContext() else { return }
            
            // Set up colors for bars
            let highPriorityColor = UIColor.red.cgColor
            let mediumPriorityColor = UIColor.orange.cgColor
            let lowPriorityColor = UIColor.yellow.cgColor
            
            // Calculate bar width and spacing dynamically based on available space
            let barWidth: CGFloat = (rect.width - 60) / 3  // 60 for spacing between bars
            let barSpacing: CGFloat = 20  // Adjust the spacing as needed
            
            let maxBarHeight = rect.height - 40 // Leave some space for margin
            
            // Calculate bar heights based on the task counts
            let highBarHeight = maxBarHeight * highPriorityCount
            let mediumBarHeight = maxBarHeight * mediumPriorityCount
            let lowBarHeight = maxBarHeight * lowPriorityCount
            
            // Draw High Priority Bar
            context.setFillColor(highPriorityColor)
            context.fill(CGRect(x: 20, y: rect.height - highBarHeight - 10, width: barWidth, height: highBarHeight))
            
            // Draw Medium Priority Bar
            context.setFillColor(mediumPriorityColor)
            context.fill(CGRect(x: 20 + barWidth + barSpacing, y: rect.height - mediumBarHeight - 10, width: barWidth, height: mediumBarHeight))
            
            // Draw Low Priority Bar
            context.setFillColor(lowPriorityColor)
            context.fill(CGRect(x: 20 + 2 * (barWidth + barSpacing), y: rect.height - lowBarHeight - 10, width: barWidth, height: lowBarHeight))
        }
    }

   
