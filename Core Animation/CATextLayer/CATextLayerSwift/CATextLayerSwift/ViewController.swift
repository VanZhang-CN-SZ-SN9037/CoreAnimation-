//
//  ViewController.swift
//  CATextLayerSwift
//
//  Created by 张小杨 on 2021/1/22.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var containV: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 150, width: 370, height: 600)
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(containV)
        
        let textLayer = CATextLayer()
        textLayer.frame = self.containV.bounds
        self.containV.layer.addSublayer(textLayer)
        
        //字体颜色
        textLayer.foregroundColor = UIColor.black.cgColor
        //字符串对齐方式
        textLayer.alignmentMode = .justified
        //自动换行
        textLayer.isWrapped = true
        
        let str = "文章1984年出生于陕西省西安市。上高三的时候，文章被保送到四川师范大学艺术学院学习影视表演，但是他并未进入这个学校，而是决心去北京学习。"
        textLayer.string = str
        
    }
}

