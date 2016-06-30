//
//  TimerAnimation.swift
//  WallBoard
//
//  Created by Ty Schultz on 6/22/16.
//  Copyright © 2016 Ty Schultz. All rights reserved.
//

import UIKit
import EasyAnimation

class TimerAnimation: UIView {

    // MARK: Properties
    
    var rating = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    var ratingButtons = [UIButton]()
    var spacing = 5
    var stars = 5
    
    var left = true
    
    var bar : UIView?
    
    // MARK: Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        bar = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 4))
        bar?.backgroundColor = UIColor.whiteColor()
        
        addSubview(bar!)
        
        moveLeft()
        
        self.layer.masksToBounds = true
        
        bar?.layer.cornerRadius = 2.0
        
        
//        let filledStarImage = UIImage(named: "filledStar")
//        let emptyStarImage = UIImage(named: "emptyStar")
//        
//        for _ in 0..<5 {
//            let button = UIButton()
//            
//            button.setImage(emptyStarImage, forState: .Normal)
//            button.setImage(filledStarImage, forState: .Selected)
//            button.setImage(filledStarImage, forState: [.Highlighted, .Selected])
//            
//            button.adjustsImageWhenHighlighted = false
//            
//            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(_:)), forControlEvents: .TouchDown)
//            ratingButtons += [button]
//            addSubview(button)
//        }
    }
    
    func moveLeft(){
        
        UIView.animateAndChainWithDuration(0.5, delay: 0.0, options: [], animations: {
            var frame = self.bar?.frame
            frame?.size.width = 150
            self.bar?.frame = frame!

            }, completion: nil).animateAndChainWithDuration(0.5, delay: 0.0, options: [], animations: {
                var frame = self.bar?.frame
                frame?.size.width = 10
                self.bar?.frame = frame!
                
                }, completion: nil)
        
        UIView.animateAndChainWithDuration(1.0, delay: 0.0, options: [], animations: {
//            self.bar?.frame = CGRect(x: self.frame.width, y: 0, width: 10, height: 22)
            self.bar?.center = CGPoint(x: self.frame.width-128, y: 11)
            }) { (Bool) in
            self.moveRight()
        }
    }
    
    func moveRight(){
        
        UIView.animateAndChainWithDuration(0.5, delay: 0.0, options: [], animations: {
            var frame = self.bar?.frame
            frame?.size.width = 150
            self.bar?.frame = frame!
            
            }, completion: nil).animateAndChainWithDuration(0.5, delay: 0.0, options: [], animations: {
                var frame = self.bar?.frame
                frame?.size.width = 10
                self.bar?.frame = frame!
                
                }, completion: nil)
        
        UIView.animateAndChainWithDuration(1.0, delay: 0.0, options: [], animations: {
            self.bar?.center = CGPoint(x: 80, y: 11)
        }) { (Bool) in
            self.moveLeft()
        }
    }
    
    
    override func layoutSubviews() {

        
        
        
        
        
//        // Set the button's width and height to a square the size of the frame's height.
//        let buttonSize = Int(frame.size.height)
//        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
//        
//        // Offset each button's origin by the length of the button plus spacing.
//        for (index, button) in ratingButtons.enumerate() {
//            buttonFrame.origin.x = CGFloat(index * (buttonSize + spacing))
//            button.frame = buttonFrame
//        }
//        updateButtonSelectionStates()
    }
    
    override func intrinsicContentSize() -> CGSize {
        let buttonSize = Int(frame.size.height)
        let width = (buttonSize + spacing) * stars
        
        return CGSize(width: width, height: buttonSize)
    }
    
    // MARK: Button Action
    
//    func ratingButtonTapped(button: UIButton) {
//        rating = ratingButtons.indexOf(button)! + 1
//        
//        updateButtonSelectionStates()
//    }
//    
//    func updateButtonSelectionStates() {
//        for (index, button) in ratingButtons.enumerate() {
//            // If the index of a button is less than the rating, that button should be selected.
//            button.selected = index < rating
//        }
//    }
}
