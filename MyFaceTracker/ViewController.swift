//
//  ViewController.swift
//  MyFaceTracker
//
//  Created by camtasia on 2016-03-11.
//  Copyright © 2016 camtasia. All rights reserved.
//

import UIKit
import FaceTracker

class ViewController: UIViewController, FaceTrackerViewControllerDelegate {

    weak var faceTrackerViewController: FaceTrackerViewController?
    
    var overlayViews = [String: [UIImageView]]()
    
    var animation = 0
    
    var updates = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "faceTrackerEmbed") {
            faceTrackerViewController = segue.destinationViewController as? FaceTrackerViewController
            faceTrackerViewController!.delegate = self
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        faceTrackerViewController!.startTracking { () -> Void in
            
        }
    }
    
    func updateViewForFeature(feature: String, index: Int, point: CGPoint, bgColor: UIColor) {
        
        let frame = CGRectMake(point.x-2, point.y-2, 4.0, 4.0)
        
        if self.overlayViews[feature] == nil {
            self.overlayViews[feature] = [UIImageView]()
        }
        
        if index < self.overlayViews[feature]!.count {
            self.overlayViews[feature]![index].frame = frame
            self.overlayViews[feature]![index].hidden = false
            self.overlayViews[feature]![index].backgroundColor = bgColor
        } else {
            let newView = UIImageView(frame: frame)
            newView.backgroundColor = bgColor
            newView.hidden = false
            self.view.addSubview(newView)
            self.overlayViews[feature]! += [newView]
        }
    }
    
    func hideAllOverlayViews() {
        
        updates = 0
        
        for (_, views) in self.overlayViews {
            for view in views {
                view.hidden = true
            }
        }
    }
    
    func getCenterPosition(sequence: EnumerateSequence<[CGPoint]>)->CGRect{
        
        var num = 0
        
        var x : CGFloat = 0
        
        var y : CGFloat = 0
        
        
        for (_,point) in sequence {
           
            num = num + 1
            
            x = x + (point.x-2)
            
            y = y + (point.y-2)
            
            
        }
        
        if num > 0 {
        
        x = x/CGFloat(num)
        
        y = y/CGFloat(num)
            
           return CGRectMake(x-25, y-25, 60.0, 60.0)
            
        }
        
        return CGRectMake(0.0, 0.0, 0.0, 0.0)
        
    }
    
    func publishAnimation(frame : CGRect, feature : String, img: String){
        
        if self.overlayViews[feature] == nil {
            self.overlayViews[feature] = [UIImageView]()
        }
        
        if self.overlayViews[feature]!.count > 0 {
            self.overlayViews[feature]![0].frame = frame
            self.overlayViews[feature]![0].hidden = false
            self.overlayViews[feature]![0].image = UIImage(named: img)
        } else {
            let newView = UIImageView(frame: frame)
            newView.hidden = false
            newView.image = UIImage(named: img)
            self.view.addSubview(newView)
            self.overlayViews[feature]! += [newView]
        }
        
    }
    
    
    
    func faceTrackerDidUpdate(points: FacePoints?) {
        if let points = points {
            
            updates = updates + 1
            
            if animation == 0 {
                
                if(updates >= 100){
                    updates = 0
                    
                    UIView.animateWithDuration(1, animations: {
                        self.overlayViews["leftEye"]![0].transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
                        self.overlayViews["rightEye"]![0].transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
                        
                        self.overlayViews["leftEye"]![0].transform = CGAffineTransformMakeRotation(0)
                        self.overlayViews["rightEye"]![0].transform = CGAffineTransformMakeRotation(0)
                        })
                    
                
                }else{
                
                let leftEye = self.getCenterPosition(points.leftEye.enumerate())
                let rightEye = self.getCenterPosition(points.rightEye.enumerate())
                
                self.publishAnimation(leftEye, feature: "leftEye", img: "heart")
                self.publishAnimation(rightEye, feature: "rightEye", img: "heart")
                }
                
            }
            else if animation == 1 {
                
                
                if(updates >= 100){
                    updates = 0
                    
                    UIView.animateWithDuration(1, animations: {
                        self.overlayViews["mouth"]![0].transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
                         self.overlayViews["mouth"]![0].transform = CGAffineTransformMakeRotation(0)

                        }
                    )
                    
                }else{

                var mouth = self.getCenterPosition(points.outerMouth.enumerate())
                
                mouth = increaseRect(mouth, percentageWidth: 1, percentageHeight: 1)
                
                
                
                self.publishAnimation(mouth, feature: "mouth", img: "lips")
                }
                
                
            }
            else if animation == 2 {
                
                if(updates >= 100){
                    updates = 0
                    
                    UIView.animateWithDuration(1, animations: {
                        self.overlayViews["mouth"]![0].transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
                        self.overlayViews["mouth"]![0].transform = CGAffineTransformMakeRotation(0)
                        
                        }
                    )
                    
                }else{
                
                var mouth = self.getCenterPosition(points.outerMouth.enumerate())
                
                mouth = increaseRect(mouth, percentageWidth: 3, percentageHeight: 1.5)
                
                self.publishAnimation(mouth, feature: "mouth", img: "mustache")
                }
                
            }
            else if animation == 3 {
                
                if(updates >= 100){
                    updates = 0
                    
                    UIView.animateWithDuration(1, animations: {
                        self.overlayViews["nose"]![0].transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
                        self.overlayViews["nose"]![0].transform = CGAffineTransformMakeRotation(0)
                        
                        }
                    )
                    
                }else{
                
                var nose = self.getCenterPosition(points.nose.enumerate())
                
                nose = increaseRect(nose, percentageWidth: 1, percentageHeight: 1)
                nose = CGRectOffset(nose, 0, -25)
                
                self.publishAnimation(nose, feature: "nose", img: "nose")
                }
                
            }
            else if animation == 4 {
                
                if(updates >= 100){
                    updates = 0
                    
                    UIView.animateWithDuration(1, animations: {
                        self.overlayViews["nose"]![0].transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
                        self.overlayViews["nose"]![0].transform = CGAffineTransformMakeRotation(0)
                        
                        }
                    )
                    
                }else{
                
                var nose = self.getCenterPosition(points.nose.enumerate())
                
                nose = increaseRect(nose, percentageWidth: 4, percentageHeight: 1.5)
                
                nose = CGRectOffset(nose, 0, -200)
                
                self.publishAnimation(nose, feature: "nose", img: "horns")
                }
                
            }
            
            
            /*
            for (index, point) in points.leftEye.enumerate() {
                self.updateViewForFeature("leftEye", index: index, point: point, bgColor: UIColor.blueColor())
            }
            
            for (index, point) in points.rightEye.enumerate() {
                self.updateViewForFeature("rightEye", index: index, point: point, bgColor: UIColor.blueColor())
            }
            
            for (index, point) in points.leftBrow.enumerate() {
                self.updateViewForFeature("leftBrow", index: index, point: point, bgColor: UIColor.whiteColor())
            }
            
            for (index, point) in points.rightBrow.enumerate()
            {
                self.updateViewForFeature("rightBrow", index: index, point: point, bgColor: UIColor.whiteColor())
            }
            
            for (index, point) in points.nose.enumerate() {
                self.updateViewForFeature("nose", index: index, point: point, bgColor: UIColor.purpleColor())
            }
            
            for (index, point) in points.innerMouth.enumerate() {
                self.updateViewForFeature("innerMouth", index: index, point: point, bgColor: UIColor.redColor())
            }
            
            for (index, point) in points.outerMouth.enumerate(){
                self.updateViewForFeature("outerMouth", index: index, point: point, bgColor: UIColor.yellowColor())
            }
 */
            
        }
        else {
            self.hideAllOverlayViews()
        }
    }
    
    func increaseRect(rect: CGRect, percentageWidth: CGFloat, percentageHeight: CGFloat) -> CGRect {
        let startWidth = CGRectGetWidth(rect)
        let startHeight = CGRectGetHeight(rect)
        let adjustmentWidth = (startWidth * percentageWidth) / 2.0
        let adjustmentHeight = (startHeight * percentageHeight) / 2.0
        return CGRectInset(rect, -adjustmentWidth, -adjustmentHeight)
    }
    
    
    @IBAction func changeAnimation(sender : UIButton){
        self.hideAllOverlayViews()
        animation = sender.tag
    }

}

