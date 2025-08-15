//
//  CALayer.swift
//  Pharma247
//
//  Created by mac42 on 28/08/19.
//  Copyright © 2019 TRooTech. All rights reserved.
//

import Foundation
import UIKit

extension CALayer{
    
    func removeAllGradiantLayers() {
        
        self.sublayers?.forEach { layer in
            
            if layer.isKind(of: CAGradientLayer.self) {
                layer.removeFromSuperlayer()
            }
        }
    }
    
    func removeAllShapeLayers() {
        
        self.sublayers?.forEach { layer in
            
            if layer.isKind(of: CAShapeLayer.self) {
                layer.removeFromSuperlayer()
            }
        }
    }
}
