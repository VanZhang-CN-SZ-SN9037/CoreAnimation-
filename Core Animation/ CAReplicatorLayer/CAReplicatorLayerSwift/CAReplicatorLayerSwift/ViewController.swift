//
//  ViewController.swift
//  CAReplicatorLayerSwift
//
//  Created by 张小杨 on 2021/1/22.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var containV: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 150, width: UIScreen.main.bounds.size.width, height: 500)
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(containV)
        
        let replicator = CAReplicatorLayer()
        replicator.frame = self.containV.bounds
        self.containV.layer.addSublayer(replicator)
        
        replicator.instanceCount = 10
        
        var transform: CATransform3D = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, 0, 200, 0)
        transform = CATransform3DRotate(transform, .pi/5, 0, 0, 1)
        transform = CATransform3DTranslate(transform, 0, -200, 0)
        
        replicator.instanceBlueOffset = -0.1
        replicator.instanceGreenOffset = -0.1
        
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        layer.backgroundColor = UIColor.white.cgColor
        replicator.addSublayer(layer)
        
    }


}

