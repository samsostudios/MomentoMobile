//
//  OnBoardButton.swift
//  Momento
//
//  Created by Sam Henry on 3/3/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit

class OnboardButton: UIButton{
    
    var isOn = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton() {
        layer.borderWidth = 2.0
        layer.borderColor = Colors.darkYellow.cgColor
        layer.cornerRadius = 10.0
        
//        layer.frame.size = CGSize(width: 150.0, height: 150.0)
        
        addTarget(self, action: #selector(OnboardButton.buttonPressed), for: .touchUpInside)
        
    }
    
    @objc func buttonPressed(){
        activateButtonSelected(bool: !isOn)
    }
    
    func activateButtonSelected(bool: Bool){
        isOn = bool
        
        let selectedColor = bool ? Colors.darkYellowOpac : .clear
        
        backgroundColor = selectedColor
    }
}
