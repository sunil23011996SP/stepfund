//
//  UIView.swift
//  Pharma247
//
//  Created by Sagar Chauhan on 14/08/19.
//  Copyright © 2019 TRooTech. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    
    // Method to set shadow with corner radius
    func setShadowWithCornerRadius(roundingCorners: UIRectCorner, cornerRadius: CGSize, fillColor: UIColor, color: UIColor, width: Double, height: Double, radius: Double, opacity: Float) {
        
        // Remove all previous shape layer
        self.layer.sublayers?.removeAll(where: { $0 is CAShapeLayer })
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: roundingCorners, cornerRadii: cornerRadius).cgPath
        shapeLayer.fillColor = fillColor.cgColor //UIColor.orange.cgColor
        shapeLayer.masksToBounds = false
        
        shapeLayer.shadowColor = color.cgColor
        shapeLayer.shadowPath = shapeLayer.path
        shapeLayer.shadowOffset = CGSize(width: width, height: height)
        shapeLayer.shadowOpacity = opacity
        shapeLayer.shadowRadius = CGFloat(radius)
        
        self.layer.insertSublayer(shapeLayer, at: 0)
    }
    
    // Method to set shadow
    func setShadow(color: UIColor, width: Double, height: Double, radius: Double, opacity: Float) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowRadius = CGFloat(radius)
        self.layer.shadowOpacity = opacity
    }
    
    // Method to set shadow with corner radius
    func setCornerRadius(roundingCorners: UIRectCorner, cornerRadius: CGSize) {
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: roundingCorners, cornerRadii: cornerRadius).cgPath
        layer.mask = shapeLayer
    }
    
    // Set dashed line
    func addDashedLine() {
        
        // Remove previous shape layer if available
        self.layer.sublayers?.removeAll(where: { (shapeLayer) -> Bool in
            return shapeLayer is CAShapeLayer
        })
        
        // Create new shape layer and insert it
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.gray.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [7, 3]
        
        let path = CGMutablePath()
        path.addLines(between: [.zero, CGPoint(x: self.frame.maxX, y: 0)])
        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
    }
    
    // Set dashed line vertically
    
    func addDashedLineVertically(whichColor color: UIColor, lineWidth: CGFloat) {
        
        self.layer.removeAllShapeLayers()
        
        // Add line
        let lineLayer = CAShapeLayer()
        lineLayer.strokeColor = color.cgColor
        lineLayer.lineWidth = lineWidth
        lineLayer.lineDashPattern = [4,4]
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: 0, y: (self.bounds.origin.y) + self.bounds.size.height)])
        lineLayer.path = path
        self.layer.addSublayer(lineLayer)
    }
    
    func setShadowWithRadius(_ radius: Double) {
        self.layer.cornerRadius = CGFloat(radius)
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor(red: 59.0/255.0, green: 59.0/255.0, blue: 59.0/255.0, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 2.0
        self.layer.masksToBounds = false
    }
    
    // Add Dashed Border To View
    func addDashedBorder(whichColor color: UIColor) {
        
        self.layer.removeAllShapeLayers()
        
        let color = color
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 10).cgPath

        self.layer.addSublayer(shapeLayer)
    }
}


enum VerticalLocation: String {
    case bottom
    case top
}


extension UIView {
    
    func animShow() {
        UIView.animate(withDuration: 0.5, delay: 0.2, options: [.curveEaseIn],
                       animations: {
                        self.center.y += self.bounds.height
                        //self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
        self.alpha = 1
    }
    
    func animHide() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],
                       animations: {
//                        self.center.y += self.bounds.height
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
                        
        },  completion: {(_ completed: Bool) -> Void in
            self.isHidden = true
            self.alpha = 0
        })
    }
    
    func fadeIn(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        self.alpha = 0.0
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.isHidden = false
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        self.alpha = 1.0
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }) { (completed) in
            self.isHidden = true
            completion(true)
        }
    }
}

//MARK:- View BorderColor, Border Width , corner radious , circle

extension UIView {
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    // Corner radius
    @IBInspectable var circle: Bool {
        get {
            return layer.cornerRadius == self.bounds.width*0.5
        }
        set {
            if newValue == true {
                self.cornerRadius = self.bounds.width*0.5
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
