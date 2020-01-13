//
//  TestViewController.swift
//  funding
//
//  Created by Daniel Nzioka on 11/1/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var text: UILabel!

    let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = CGPoint(x: 100, y: 100)
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: center, radius: 20, startAngle: -CGFloat.pi/2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 5
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        container.layer.addSublayer(trackLayer)
        
    
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0
        
        let label = CATextLayer()
        label.frame = label.frame
        label.string = "someString"
        label.isHidden = false
        label.fontSize = 25.0

        shapeLayer.addSublayer(label)
        container.layer.addSublayer(label)
        
        container.layer.addSublayer(shapeLayer)
        
        text.textColor = .white
        text.bringSubviewToFront(self.view)
        
        loadUp()
        
        //view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
    }
    
    func loadUp() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 1.2
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }

}
