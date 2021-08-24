//
//  LWImageView.swift
//  BSTextDemo
//
//  Created by 罗威 on 2021/8/24.
//  Copyright © 2021 GeekBruce. All rights reserved.
//

import Foundation
import UIKit

class scableImageView:UIView, UIGestureRecognizerDelegate{
    var dotView:UIView!
    weak var delegate:BSTextAttachmentExample!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI(){
        weak var wlabel = self
        let dot: UIView? = newDotView()
        dot?.center = CGPoint(x: self.width, y: self.height)
        dot?.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin]
        if let dot = dot {
            self.addSubview(dot)
        }
        let gesture = BSGestureRecognizer()
        gesture.targetView = self
        gesture.action = { gesture, state in
            if state != BSGestureRecognizerState.moved {
                return
            }
            let width = gesture!.currentPoint.x
            let height = gesture!.currentPoint.y
            wlabel?.width = width < 30 ? 30 : width
            wlabel?.height = height < 30 ? 30 : height
            print("self.frame:\(self.frame)")
        }
        gesture.delegate = self
        
        dot?.addGestureRecognizer(gesture)
    }
    
    func newDotView() -> UIView? {
        let view = UIView()
        view.size = CGSize(width: 50, height: 50)
        
        let dot = UIView()
        dot.size = CGSize(width: 20, height: 20)
        dot.backgroundColor = UIColor(red: 0.000, green: 0.463, blue: 1.000, alpha: 1.000)
        dot.clipsToBounds = true
        dot.layer.cornerRadius = dot.height / 2
        dot.center = CGPoint(x: view.width / 2, y: view.height / 2)
        view.addSubview(dot)
        
        return view
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        super.gestureRecognizerShouldBegin(gestureRecognizer)
        let p: CGPoint = gestureRecognizer.location(in: self)
        if p.x < self.width - 20 {
            return false
        }
        if p.y < self.height - 20 {
            return false
        }
        return true
    }
}
