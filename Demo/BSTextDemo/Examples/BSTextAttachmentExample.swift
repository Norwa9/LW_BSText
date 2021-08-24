//
//  BSTextAttachmentExample.swift
//  BSTextDemo
//
//  Created by BlueSky on 2019/1/19.
//  Copyright © 2019 GeekBruce. All rights reserved.
//

import UIKit
import BSText
import YYImage

class BSTextAttachmentExample: UIViewController, UIGestureRecognizerDelegate {
    
    private let textView = BSTextView()
    var view1AttributedString:NSMutableAttributedString!
    var view1:scableImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        BSTextExampleHelper.addDebugOption(to: self)
        
        
        let text = NSMutableAttributedString()
        let font = UIFont.systemFont(ofSize: 16)
        
        do {
            let title = "This is UIImageView attachment: "
            text.append(NSAttributedString(string: title, attributes: nil))
            
            view1 = scableImageView(frame: CGRect(origin: .zero, size: CGSize(width: 200, height: 200)))
            view1.backgroundColor = .black
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
            view1.addGestureRecognizer(tapGes)
            view1.delegate = self
            view1.index = text.length
            
            view1AttributedString = NSMutableAttributedString.bs_attachmentString(with: view1, contentMode: UIView.ContentMode.center, attachmentSize: view1.size, alignTo: nil, alignment: TextVerticalAlignment.top)
            text.append(view1AttributedString!)
            text.append(NSAttributedString(string: "\n", attributes: nil))
        }
        
        
        
        do {
            
            let title = "This is Animated Image attachment:"
            text.append(NSAttributedString(string: title, attributes: nil))
            
            let names = ["001@2x", "022@2x", "019@2x", "056@2x", "085@2x"]
            for name: String in names {
                let path = Bundle.main.path(forResource: name, ofType: "gif", inDirectory: "EmoticonQQ.bundle")
                let data = NSData(contentsOfFile: path!) as Data?
                var image: YYImage? = nil
                if let data = data {
                    image = YYImage(data: data, scale: 2)
                }
                image?.preloadAllAnimatedImageFrames = true
                var imageView: YYAnimatedImageView? = nil
                if let image = image {
                    imageView = YYAnimatedImageView(image: image)
                }
                
                let attachText = NSMutableAttributedString.bs_attachmentString(with: imageView, contentMode: UIView.ContentMode.center, attachmentSize: imageView!.size, alignTo: font, alignment: TextVerticalAlignment.center)
                text.append(attachText!)
            }
            
            let image = YYImage(named: "pia")
            image?.preloadAllAnimatedImageFrames = true
            var imageView: YYAnimatedImageView? = nil
            if let image = image {
                imageView = YYAnimatedImageView(image: image)
            }
            imageView?.autoPlayAnimatedImage = false
            imageView?.startAnimating()
            
            let attachText = NSMutableAttributedString.bs_attachmentString(with: imageView, contentMode: UIView.ContentMode.center, attachmentSize: imageView!.size, alignTo: font, alignment: TextVerticalAlignment.bottom)
            text.append(attachText!)
            
            text.append(NSAttributedString(string: "\n", attributes: nil))
        }
        
        
        text.bs_font = font
        
        textView.isUserInteractionEnabled = true
        textView.textVerticalAlignment = TextVerticalAlignment.top
        textView.frame = view.frame
        textView.attributedText = text
        view.addSubview(textView)
        
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor(red: 0.000, green: 0.463, blue: 1.000, alpha: 1.000).cgColor
        
        
        weak var wlabel = textView
        let dot: UIView? = newDotView()
        dot?.center = CGPoint(x: textView.width, y: textView.height)
        dot?.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin]
        if let dot = dot {
            textView.addSubview(dot)
        }
        let gesture = BSGestureRecognizer()
        gesture.targetView = textView
        gesture.action = { gesture, state in
            if state != BSGestureRecognizerState.moved {
                return
            }
            let width = gesture!.currentPoint.x
            let height = gesture!.currentPoint.y
            wlabel?.width = width < 30 ? 30 : width
            wlabel?.height = height < 30 ? 30 : height
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
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let p: CGPoint = gestureRecognizer.location(in: textView)
        if p.x < textView.width - 20 {
            return false
        }
        if p.y < textView.height - 20 {
            return false
        }
        return true
    }
    
    @objc func tapAction(_ sender:UITapGestureRecognizer){
        print("tapped view 1")
//        let origin = view1.origin
//        let rand = Int.random(in: 1..<4)
//        print("rand = \(rand)")
//        view1.frame = CGRect(origin: origin, size: CGSize(width: 50 * rand, height: 50 * rand))
        for attribute in view1AttributedString.attributes(at: 0, effectiveRange: nil){
            if let attchemnt = attribute.value as? TextAttachment{
                attchemnt.contentMode = .scaleAspectFill
                attchemnt.contentInsets = .zero
                if let view = attchemnt.content as? UIView{
                    let rand = Int.random(in: 1..<4)
                    print("rand = \(rand)")
                    view.frame = CGRect(origin: .zero, size: CGSize(width: 50 * rand, height: 50 * rand))
                    
                    print("view.frame:\(view.frame)")
                }
            }
        }
    }
    
    func reloadScableImage(view:scableImageView){
        let endFrame = view.frame
        let convertedFrame = textView.convert(endFrame, from: view)
        print("convertedFrame:\(convertedFrame)")
        
        let newView = scableImageView(frame: endFrame)
        newView.index = view.index
        newView.delegate = self
        newView.backgroundColor = .green
        let newAttchmentString = NSMutableAttributedString.bs_attachmentString(with: newView, contentMode: .scaleAspectFill, attachmentSize: newView.size, alignTo: nil, alignment: .center)!
        
        let mutable = NSMutableAttributedString(attributedString: textView.attributedText!)
        let replaceRange = NSRange(location: view.index, length: 1)
        mutable.replaceCharacters(in: replaceRange, with: newAttchmentString)
        textView.attributedText = mutable
        
        
//        let path  = UIBezierPath(rect: convertedFrame)
//        textView.exclusionPaths = [path]
    }
}
