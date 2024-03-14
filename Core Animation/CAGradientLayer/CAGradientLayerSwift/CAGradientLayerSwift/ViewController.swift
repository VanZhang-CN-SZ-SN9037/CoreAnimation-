//
//  ViewController.swift
//  CAGradientLayerSwift
//
//  Created by 张小杨 on 2021/1/22.
//

import UIKit

class ViewController: UIViewController {
    lazy var containV: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 80, y: 150, width: 200, height: 200)
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(containV)
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = self.self.containV.bounds
        self.containV.layer.addSublayer(gradientLayer)
        
        let startColor = UIColor.red.cgColor
        let minddleColor = UIColor.yellow.cgColor
        let endColor = UIColor.green.cgColor
        
        gradientLayer.colors = [startColor, minddleColor, endColor]
        
        gradientLayer.locations = [0.0, 0.25, 0.5]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
    }
    
}

