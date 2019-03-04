//
//  YellowGradient.swift
//  Momento
//
//  Created by Sam Henry on 3/3/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setGradient(colorOne: UIColor, colorTwo: UIColor){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
