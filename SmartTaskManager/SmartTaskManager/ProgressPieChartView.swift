//
//  ProgressPieChartView.swift
//  SmartTaskManager
//
//  Created by CDMStudent on 3/17/25.
//

import UIKit

class ProgressPieChartView: UIView {

        var completedPercentage: CGFloat = 0.0 // Between 0 and 1
        var pendingPercentage: CGFloat = 0.0   // Between 0 and 1
        
        override func draw(_ rect: CGRect) {
            guard let context = UIGraphicsGetCurrentContext() else { return }
            
            let radius = min(bounds.width, bounds.height) / 2

            let center = CGPoint(x: bounds.midX, y: bounds.midY)

            context.setFillColor(UIColor.green.cgColor)
            context.move(to: center)
            context.addArc(center: center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle: -CGFloat.pi / 2 + 2 * CGFloat.pi * completedPercentage, clockwise: false)
            context.closePath()
            context.fillPath()

            // Draw pending tasks part
            context.setFillColor(UIColor.red.cgColor)
            context.move(to: center)
            context.addArc(center: center, radius: radius, startAngle: -CGFloat.pi / 2 + 2 * CGFloat.pi * completedPercentage, endAngle: CGFloat.pi * 1.5, clockwise: false)
            context.closePath()
            context.fillPath()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            self.setNeedsDisplay()
        }
    }
