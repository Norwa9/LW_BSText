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
    var index:Int!
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
            if state == BSGestureRecognizerState.moved {
                let width = gesture!.currentPoint.x
                let height = gesture!.currentPoint.y
                wlabel?.width = width < 30 ? 30 : width
                wlabel?.height = height < 30 ? 30 : height
            }else if state == .ended{
                self.delegate.reloadScableImage(view: self)
            }
            
        }
        gesture.delegate = self
        
        dot?.addGestureRecognizer(gesture)
    }
    
    func newDotView() -> UIView? {
        let view = UIView()
        view.size = CGSize(width: 50, height: 50)
        
        let dot = UIView()
        dot.size = CGSize(width: 30, height: 30)
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
    
    /// 子视图超出本视图的部分也能接收事件
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    
        if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01 ){
            return nil
        }
        let resultView  = super.hitTest(point, with: event)
        if resultView != nil {
            return resultView
        } else {
            for subView in self.subviews.reversed() {
                // 这里根据层级的不同，需要遍历的次数可能不同，看需求来写，我写的例子是一层的
                let convertPoint : CGPoint = subView.convert(point, from: self)
                let hitView = subView.hitTest(convertPoint, with: event)
                if (hitView != nil) {
                    return hitView
                }
            }
        }
        return nil
    }
}
