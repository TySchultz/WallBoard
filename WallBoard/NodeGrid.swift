//
//  NodeGrid.swift
//  WallBoard
//
//  Created by Ty Schultz on 6/22/16.
//  Copyright © 2016 Ty Schultz. All rights reserved.
//

import UIKit

class NodeGrid: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    //: [Previous](@previous)
//    
//    import Foundation
//    import UIKit
//    import XCPlayground
//    
//    let squareSize = 500
//    
//    let numberOfDots = 5
//    let numberOfSources = 1
//    
//    let animationTime = 1.0
//    
//    var window = UIView(frame: CGRect(x: 0, y: 0, width: squareSize, height: squareSize))
//    window.backgroundColor = UIColor(red:0.6, green: 0.65, blue: 0.69, alpha: 1.0)
//    
//    XCPShowView("mindNode", view: window)
//    
//    let floatPadding :CGFloat = 50
//    var starts :NSMutableArray = []
//    
//    let rightEdge = window.frame.size.width-floatPadding*2
//    let leftEdge :CGFloat = 0.0
//    let top :CGFloat = 0.0
//    let bottom = window.frame.size.height-floatPadding*2
//    let size = window.frame.size.width-floatPadding*2
//    
//    var linesGroups :NSMutableArray = []
//    //
//    for var i=0; i < numberOfDots; i++ {
//    var ee :NSMutableArray = []
//    linesGroups.addObject(ee)
//    }
//    
//    for var i=0; i < numberOfSources; i++ {
//    var xValue = Int(arc4random_uniform(400))
//    var yValue = Int(arc4random_uniform(400))
//    var center = window.center
//    addLineToGroups(linesGroups, point: CGPoint(x: center.x,    y: center.y), window: window)
//    }
//    
//    for var i=0; i<numberOfSources; i++ {
//    let lineGroup : NSMutableArray = linesGroups.objectAtIndex(0) as! NSMutableArray
//    myPathApply(lineGroup[i].path) { element in
//    if(element.memory.type == CGPathElementType.MoveToPoint){
//    
//    print("move(\(element.memory.points[0]))")
//    starts.addObject(NSValue(CGPoint:element.memory.points[0]))
//    }
//    }
//    }
//    
//    
//    var newPointsGroup :NSMutableArray = []
//    var newViewGroup :NSMutableArray = []
//    let viewColor = UIColor.whiteColor().colorWithAlphaComponent(1.0)
//    
//    for var i=0; i < numberOfDots; i++ {
//    var newPoint = CGPoint(x: 100, y: 100)
//    newPointsGroup.addObject(NSValue(CGPoint: newPoint))
//    
//    var height = Int(arc4random_uniform(16))+4
//    
//    let view = UIView(frame: (CGRect(x: 100, y: 100, width: height, height: height)))
//    view.backgroundColor = viewColor
//    view.layer.cornerRadius = view.frame.size.width/2
//    window.addSubview(view)
//    
//    newViewGroup.addObject(view)
//    }
//    
//    //let title = UILabel(frame: CGRect(x: 0, y: 0, width: 350, height: 64))
//    //title.text = "Node Cloud Playground"
//    //title.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
//    //title.layer.borderColor = UIColor.whiteColor().CGColor
//    //title.layer.borderWidth = 3.0;
//    //title.textAlignment = NSTextAlignment.Center
//    //title.font = UIFont(name: "Avenir-Heavy", size: 24)
//    //title.textColor = UIColor.whiteColor()
//    //title.center = window.center
//    //window.addSubview(title)
//    
//    move(starts, numberOfSources: numberOfSources, numberOfDots: numberOfDots, linesGroups: linesGroups, pointsGroup: newPointsGroup,viewsGroup: newViewGroup, counter: 0)
//    
//    
//    import Foundation
//    import UIKit
//    
//    
//    public typealias MyPathApplier = @convention(block) (UnsafePointer<CGPathElement>) -> Void
//    // Note: You must declare MyPathApplier as @convention(block), because
//    // if you don't, you get "fatal error: can't unsafeBitCast between
//    // types of different sizes" at runtime, on Mac OS X at least.
//    
//    public func myPathApply(path: CGPath!, block: MyPathApplier) {
//        let callback: @convention(c) (UnsafeMutablePointer<Void>, UnsafePointer<CGPathElement>) -> Void = { (info, element) in
//            let block = unsafeBitCast(info, MyPathApplier.self)
//            block(element)
//        }
//        
//        CGPathApply(path, unsafeBitCast(block, UnsafeMutablePointer<Void>.self), unsafeBitCast(callback, CGPathApplierFunction.self))
//    }
//    
//    public func addLineToGroups(groups:NSArray, point:CGPoint, window:UIView){
//        for lines in groups{
//            newLineWithCorner(cornerPoint: point,  view: window, arrayOfLines: lines as! NSMutableArray)
//        }
//    }
//    
//    
//    
//    public func newPathFromCorner(cornerPoint point:CGPoint) ->UIBezierPath{
//        let bezierPath = UIBezierPath()
//        bezierPath.moveToPoint(point)
//        bezierPath.addLineToPoint(CGPoint(x: 150, y: 150))
//        UIColor.blueColor().setStroke()
//        bezierPath.lineWidth = 1
//        return bezierPath
//    }
//    
//    
//    public func newLineWithCorner(cornerPoint point:CGPoint, view window:UIView, arrayOfLines lines:NSMutableArray) ->CAShapeLayer{
//        
//        let line = CAShapeLayer()
//        line.path = newPathFromCorner(cornerPoint: point).CGPath
//        line.strokeColor = UIColor.whiteColor().colorWithAlphaComponent(0.2).CGColor
//        
//        
//        window.layer.addSublayer(line)
//        lines.addObject(line)
//        return line
//    }
//    
//    public func animateToPoint(startPoint start:CGPoint,endPoint end:CGPoint,shape line:CAShapeLayer){
//        
//        
//        let bezierPath3 = UIBezierPath()
//        bezierPath3.moveToPoint(start)
//        bezierPath3.addLineToPoint(end)
//        bezierPath3.lineWidth = 1
//        //
//        
//        let pathAnimation = CABasicAnimation(keyPath: "path")
//        
//        pathAnimation.duration = 1.0;
//        pathAnimation.fromValue = line.path;
//        pathAnimation.toValue = bezierPath3.CGPath;
//        pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        
//        line.addAnimation(pathAnimation, forKey: "path")
//        line.path = bezierPath3.CGPath
//        
//        
//    }
//    
//    
//    public func move(starts : NSMutableArray, numberOfSources :NSInteger, numberOfDots :NSInteger, linesGroups : NSMutableArray, pointsGroup : NSMutableArray, var viewsGroup : NSMutableArray, var counter : NSInteger){
//        
//        pointsGroup.removeAllObjects()
//        if counter == 3 {
//            for var i=0; i < numberOfDots; i++ {
//                let xValue = 250
//                let yValue = 250
//                
//                let newPoint = CGPoint(x: xValue, y: yValue )
//                pointsGroup.addObject(NSValue(CGPoint: newPoint))
//            }
//            
//        }else if counter == 4 {
//            var maxSize :CGFloat = 0
//            for view in viewsGroup {
//                if view.frame.size.height > maxSize {
//                    maxSize = view.frame.size.height
//                    
//                }
//            }
//            
//            let tmpViews :NSMutableArray = []
//            
//            for var i=0; i < viewsGroup.count; i++ {
//                let view :UIView = viewsGroup.objectAtIndex(i) as! UIView
//                view.frame  = CGRect(x: 0, y: 0, width: maxSize, height: maxSize)
//                view.center = CGPoint(x: 250, y: 250)
//                view.layer.cornerRadius = maxSize/2
//                
//                tmpViews.addObject(view)
//            }
//            
//            viewsGroup = tmpViews
//            
//            for var i=0; i < numberOfDots; i++ {
//                let xValue = 100*i+50
//                let yValue = 250
//                
//                let newPoint = CGPoint(x: xValue, y: yValue )
//                pointsGroup.addObject(NSValue(CGPoint: newPoint))
//            }
//            
//            
//            
//        }else{
//            for var i=0; i < numberOfDots; i++ {
//                let xValue = Int(arc4random_uniform(450))+50
//                let yValue = Int(arc4random_uniform(450))+50
//                
//                let newPoint = CGPoint(x: xValue, y: yValue )
//                pointsGroup.addObject(NSValue(CGPoint: newPoint))
//            }
//            
//        }
//        counter++
//        
//        UIView.animateWithDuration(1.0) { () -> Void in
//            for var i=0; i < numberOfDots; i++ {
//                let view  : UIView  = viewsGroup.objectAtIndex(i) as! UIView
//                let point : NSValue = pointsGroup.objectAtIndex(i) as! NSValue
//                
//                view.center = point.CGPointValue()
//            }
//        };
//        
//        
//        for var i=0; i<numberOfSources; i++ {
//            let value = starts[i] as! NSValue
//            let startPoint :CGPoint = value.CGPointValue()
//            
//            _ = startPoint.x
//            _ = startPoint.y
//            //        startPoint = CGPoint(x: x + CGFloat(arc4random_uniform(100)), y: y + CGFloat(arc4random_uniform(80)))
//            
//            for var e=0; e < numberOfDots; e++ {
//                let point :NSValue = pointsGroup.objectAtIndex(e) as! NSValue
//                let lineGroup = linesGroups.objectAtIndex(e) as! NSMutableArray
//                let singleLine = lineGroup.objectAtIndex(i) as! CAShapeLayer
//                animateToPoint(startPoint: startPoint, endPoint: point.CGPointValue(), shape: singleLine)
//            }
//            
//        }
//        
//        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
//                                      Int64(1.0 * Double(NSEC_PER_SEC)))
//        
//        dispatch_after(delayTime, dispatch_get_main_queue()) {
//            move(starts,numberOfSources: numberOfSources, numberOfDots: numberOfDots, linesGroups: linesGroups,pointsGroup: pointsGroup,viewsGroup: viewsGroup, counter: counter)
//        }
//    }
//

}


