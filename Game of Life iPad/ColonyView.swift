//
//  ColonyView.swift
//  Game of Life iPad
//
//  Created by Ben Shteinfeld on 1/2/15.
//  Copyright (c) 2015 Ben Shteinfeld. All rights reserved.
//

import Foundation
import UIKit

class ColonyView: UIView {
    // cell that is currently touched
    var curCellTouched: (Int, Int) = (-1, -1)
    var cellColor: UIColor = UIColor.greenColor()
    var colony: Colony = Colony()
    // size of graphical cells
    var cellSize: Float = -1.0
    var touchSettingAlive = true
    
    // initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // paints the views
    override func drawRect(rect: CGRect) {
        // get current graphics context
        let ctx: CGContextRef = UIGraphicsGetCurrentContext()
        // get bounds
        let bounds: CGRect = self.bounds
        self.backgroundColor = UIColor.clearColor()
        
        // calculate cell size
        cellSize = Float(bounds.width) / Float(colony.cols);
        
        // iterate through cells, painting alive ones
        for r in 0..<colony.rows {
            for c in 0..<colony.cols {
                // determine color to paint based on livliness of current cell
                if colony.isCellAliveAtRow(r, col: c) {
                    cellColor = UIColor.greenColor()
                } else {
                    cellColor = UIColor.whiteColor()
                }
                // draw cell
                cellColor.setFill()
                let cell: CGRect = CGRect(x: CGFloat(Float(cellSize) * Float(c) + 1.0), y: CGFloat(Float(cellSize) * Float(r) + 1.0), width: CGFloat(cellSize - 2.0), height: CGFloat(cellSize - 2.0))
                CGContextFillRect(ctx, cell)
            }
        }
        
        // draw green border
        self.layer.borderColor = UIColor.greenColor().CGColor
        self.layer.borderWidth = 1.0
    }
    
    // compares equality of tuples
    func notEqual <T:Equatable> (tuple1:(T,T),tuple2:(T,T)) -> Bool
    {
        return (tuple1.0 != tuple2.0) || (tuple1.1 != tuple2.1)
    }
    
    // paint new cells at they are touched
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        // get touch from set
        let touch: UITouch = touches.anyObject() as UITouch
        // get location of touch
        let point = touch.locationInView(self)
        // convert location to coordinates of cell in colony
        let row = Int(Float(point.y) / Float(cellSize))
        let col = Int(Float(point.x) / Float(cellSize))
        
        // check if the touched cell is already touched and that it is a valid cell
        if notEqual(curCellTouched, tuple2: (row, col)) && row < colony.rows && col < colony.cols {
            // if the cell is alive, set it dead, else set it alive
            if colony.isCellAliveAtRow(row, col: col) {
                colony.setCellDeadAtRow(row, col: col)
                touchSettingAlive = false
            } else {
                colony.setCellAliveAtRow(row, col: col)
                touchSettingAlive = true
            }
            // update current cell touched
            curCellTouched = (row, col)
            // update view
            self.setNeedsDisplay()
        }
    }
    
    // paint new cells as touches are moved (dragged)
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch: UITouch = touches.anyObject() as UITouch
        let point = touch.locationInView(self)
        let row = Int(Float(point.y) / Float(cellSize))
        let col = Int(Float(point.x) / Float(cellSize))
        
        if notEqual(curCellTouched, tuple2: (row, col)) && row < colony.rows && col < colony.cols {
            if touchSettingAlive {
                colony.setCellAliveAtRow(row, col: col)
            } else {
                colony.setCellDeadAtRow(row, col: col)
            }
            curCellTouched = (row, col)
            self.setNeedsDisplay()
        }
    }
    
}