//
//  OverlayView.swift
//  OpenCVBackgroundSubtraction
//
//  Created by Jasmeet Kaur on 25/03/17.
//  Copyright © 2017 Jasmeet Kaur. All rights reserved.
//

import UIKit

class OverlayView: UIView {
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    /*override func draw(_ rect: CGRect) {
     // Drawing code
     
     }*/
    
    
    
    static var BORDER_COLOR = UIColor.white
    static var BORDER_SIDE_VIEW_BORDER_WIDTH:CGFloat = 3.0
    static var kResizeThumbSize:CGFloat = 44.0
    static var minRectWidthHeight:CGFloat = 70.0
    
    private typealias `Self` = OverlayView
    
    var imageView = UIImageView()
    var touchStart = CGPoint()
    
    
    var isResizingLeftEdge:Bool = false
    var isResizingRightEdge:Bool = false
    var isResizingTopEdge:Bool = false
    var isResizingBottomEdge:Bool = false
    
    var isResizingBottomRightCorner:Bool = false
    var isResizingLeftCorner:Bool = false
    var isResizingRightCorner:Bool = false
    var isResizingBottomLeftCorner:Bool = false
    var borderView = UIView()
    var viewLeft,viewRight,viewBottomLeft,viewBottomRight:UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //Define your initialisers here
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            
            touchStart = touch.location(in: self.imageView)
            
            isResizingBottomRightCorner = (self.bounds.size.width - currentPoint.x < Self.kResizeThumbSize && self.bounds.size.height - currentPoint.y < Self.kResizeThumbSize);
            isResizingLeftCorner = (currentPoint.x < Self.kResizeThumbSize && currentPoint.y < Self.kResizeThumbSize);
            isResizingRightCorner = (self.bounds.size.width-currentPoint.x < Self.kResizeThumbSize && currentPoint.y < Self.kResizeThumbSize);
            isResizingBottomLeftCorner = (currentPoint.x < Self.kResizeThumbSize && self.bounds.size.height - currentPoint.y < Self.kResizeThumbSize);
            
            isResizingLeftEdge = (currentPoint.x < Self.kResizeThumbSize/2 && currentPoint.x > -Self.kResizeThumbSize/2)
            isResizingTopEdge = (currentPoint.y < Self.kResizeThumbSize)
            isResizingRightEdge = (self.bounds.size.width - currentPoint.x < Self.kResizeThumbSize)
            
            isResizingBottomEdge = (self.bounds.size.height - currentPoint.y < Self.kResizeThumbSize)
            
            
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // let location = (touch as! UITouch).locationInNode(symbolsLayer)
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self.imageView)
        
        
        
        var x = self.frame.origin.x
        var y = self.frame.origin.y
        
        var  width = self.frame.size.width
        var height = self.frame.size.height
        
        let deltaX = currentPoint.x - touchStart.x
        let deltaY = currentPoint.y - touchStart.y
        if (isResizingLeftCorner || isResizingRightCorner){
            
            width =   isResizingLeftCorner ? width - deltaX : width + deltaX
            height =  height - deltaY
            x = isResizingLeftCorner ?  self.frame.origin.x + deltaX : self.frame.origin.x
            y = self.frame.origin.y + deltaY
            
            
        } else  if (isResizingBottomLeftCorner || isResizingBottomRightCorner){
            
            width =   isResizingBottomLeftCorner ? width - deltaX : width + deltaX
            height =  height + deltaY
            x = isResizingBottomLeftCorner ?  self.frame.origin.x + deltaX : self.frame.origin.x
            y = self.frame.origin.y
            
            
        }
            
            
        else if(isResizingLeftEdge || isResizingRightEdge){
            
            width =   isResizingLeftEdge ? width - deltaX : width + deltaX
            x = isResizingLeftEdge ?  self.frame.origin.x + deltaX : self.frame.origin.x
        }
        else if(isResizingBottomEdge || isResizingTopEdge){
            
            height =   isResizingTopEdge ? height - deltaY : height + deltaY
            y = isResizingTopEdge ? self.frame.origin.y + deltaY : self.frame.origin.y
            
            
            
        }
        
        if(x >= -10  && y >= -10 && width - 20 <= self.imageView.frame.size.width && height - 20 <= self.imageView.frame.size.height && width >= Self.minRectWidthHeight && height  >= Self.minRectWidthHeight ){
        
        self.frame = CGRect(x:x,y:y,width:width,height:height)
            touchStart = currentPoint
            
        }
        
        
        
        
    }
    
    
    
    
    func isResizing()->Bool{
        
        
        if(isResizingTopEdge || isResizingLeftEdge || isResizingRightEdge || isResizingBottomEdge || isResizingLeftCorner || isResizingBottomLeftCorner || isResizingBottomRightCorner || isResizingRightCorner){
            
            
            return true
            
        }
        return false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            // do something with your currentPoint
            
            
            
            
            isResizingLeftEdge = false
            isResizingRightEdge = false
            isResizingTopEdge = false
            isResizingBottomEdge = false
            
            isResizingBottomRightCorner = false
            isResizingLeftCorner = false
            isResizingRightCorner = false
            isResizingBottomLeftCorner = false
            
        }
    }
    
    
    func addPanGesture(imageView:UIImageView){
        
        self.imageView = imageView
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.isUserInteractionEnabled = true
        //self.addGestureRecognizer(gestureRecognizer)
    }
    
    
    //MARK : function to handle Pan
    func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: self)
            
            // note: 'view' is optional and need to be unwrapped
            // let (width,height) = getImageWidthHeight()
            
            let width = self.imageView.frame.size.width
            let height = self.imageView.frame.size.height
            let x = self.imageView.frame.origin.x
            let y = self.imageView.frame.origin.y
            
            let upperBound = y
            let lowerBound = height + y
            
            let leftBound = x
            let rightBound = width + x
            
            
            
            if(gestureRecognizer.view!.frame.origin.x + gestureRecognizer.view!.frame.size.width + translation.x < rightBound && gestureRecognizer.view!.frame.origin.x +  translation.x >  leftBound && gestureRecognizer.view!.frame.origin.y + gestureRecognizer.view!.frame.size.height + translation.y < lowerBound && gestureRecognizer.view!.frame.origin.y +  translation.y >  upperBound && !isResizing()){
                gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
                gestureRecognizer.setTranslation(CGPoint.zero, in: self)
            }
        }
        
        
        
        
        
        
    }
    
    
    func createSideViews(){
        
        
        
        //BorderView
        
        borderView = UIView.init()
        //self.backgroundColor = UIColor.black
        borderView.layer.borderColor = Self.BORDER_COLOR.cgColor
        borderView.layer.borderWidth = 2.0
        
        self.addSubview(borderView)
        
        
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        var views = ["borderView" : borderView]
        var formatString = "H:|-(10)-[borderView]-(10)-|"
        var verticalConstraint = "V:|-(10)-[borderView]-(10)-|"
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: formatString, options: .directionLeadingToTrailing, metrics: nil, views:views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: verticalConstraint, options: .directionLeadingToTrailing, metrics: nil, views: views))
        
        //LeftView
        viewLeft = UIView.init()
        
        viewLeft.borders(for: [.left, .top], width: Self.BORDER_SIDE_VIEW_BORDER_WIDTH, color: Self.BORDER_COLOR)
        viewLeft.bringSubview(toFront: self)
        self.addSubview(viewLeft)
        
        viewLeft.translatesAutoresizingMaskIntoConstraints = false
        
        views = ["viewLeft" : viewLeft]
        formatString = "H:|-(8)-[viewLeft(20)]"
        verticalConstraint = "V:|-(8)-[viewLeft(20)]"
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: formatString, options: .directionLeadingToTrailing, metrics: nil, views:views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: verticalConstraint, options: .directionLeadingToTrailing, metrics: nil, views: views))
        
        
        //RightView
        
        viewRight = UIView.init()
        
        viewRight.borders(for: [.right , .top], width: Self.BORDER_SIDE_VIEW_BORDER_WIDTH, color: Self.BORDER_COLOR)
        viewRight.bringSubview(toFront: self)
        self.addSubview(viewRight)
        viewRight.translatesAutoresizingMaskIntoConstraints = false
        
        views = ["viewRight" : viewRight]
        formatString = "H:[viewRight(20)]-(8)-|"
        verticalConstraint = "V:|-(8)-[viewRight(20)]"
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: formatString, options: .directionLeadingToTrailing, metrics: nil, views:views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: verticalConstraint, options: .directionLeadingToTrailing, metrics: nil, views: views))
        
        
        //BottomRight
        viewBottomRight = UIView.init()
        
        viewBottomRight.borders(for: [.right, .bottom], width: Self.BORDER_SIDE_VIEW_BORDER_WIDTH, color: Self.BORDER_COLOR)
        viewBottomRight.bringSubview(toFront: self)
        self.addSubview(viewBottomRight)
        viewBottomRight.translatesAutoresizingMaskIntoConstraints = false
        
        
        views = ["viewBottomRight" : viewBottomRight]
        formatString = "H:[viewBottomRight(20)]-(8)-|"
        verticalConstraint = "V:[viewBottomRight(20)]-(8)-|"
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: formatString, options: .directionLeadingToTrailing, metrics: nil, views:views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: verticalConstraint, options: .directionLeadingToTrailing, metrics: nil, views: views))
        
        
        
        //BottomLeft
        viewBottomLeft = UIView.init()
        
        viewBottomLeft.borders(for: [.left, .bottom], width: Self.BORDER_SIDE_VIEW_BORDER_WIDTH, color: Self.BORDER_COLOR)
        viewBottomLeft.bringSubview(toFront: self)
        self.addSubview(viewBottomLeft)
        viewBottomLeft.translatesAutoresizingMaskIntoConstraints = false
        
        
        views = ["viewBottomLeft" : viewBottomLeft]
        formatString = "H:|-(8)-[viewBottomLeft(20)]"
        verticalConstraint = "V:[viewBottomLeft(20)]-(8)-|"
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: formatString, options: .directionLeadingToTrailing, metrics: nil, views:views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: verticalConstraint, options: .directionLeadingToTrailing, metrics: nil, views: views))
        
        
        
        
        
        
    }
    
    
    
    
}

extension UIView {
    func borders(for edges:[UIRectEdge], width:CGFloat = 1, color: UIColor = .black) {
        
        if edges.contains(.all) {
            layer.borderWidth = width
            layer.borderColor = color.cgColor
        } else {
            let allSpecificBorders:[UIRectEdge] = [.top, .bottom, .left, .right]
            
            for edge in allSpecificBorders {
                if let v = viewWithTag(Int(edge.rawValue)) {
                    v.removeFromSuperview()
                }
                
                if edges.contains(edge) {
                    let v = UIView()
                    v.tag = Int(edge.rawValue)
                    v.backgroundColor = color
                    v.translatesAutoresizingMaskIntoConstraints = false
                    addSubview(v)
                    
                    var horizontalVisualFormat = "H:"
                    var verticalVisualFormat = "V:"
                    
                    switch edge {
                    case UIRectEdge.bottom:
                        horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                        verticalVisualFormat += "[v(\(width))]-(0)-|"
                    case UIRectEdge.top:
                        horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                        verticalVisualFormat += "|-(0)-[v(\(width))]"
                    case UIRectEdge.left:
                        horizontalVisualFormat += "|-(0)-[v(\(width))]"
                        verticalVisualFormat += "|-(0)-[v]-(0)-|"
                    case UIRectEdge.right:
                        horizontalVisualFormat += "[v(\(width))]-(0)-|"
                        verticalVisualFormat += "|-(0)-[v]-(0)-|"
                    default:
                        break
                    }
                    
                    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: horizontalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
                    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: verticalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
                }
            }
        }
    }
}
