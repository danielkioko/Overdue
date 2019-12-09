//
//  IntroViewController.swift
//  funding
//
//  Created by Daniel Nzioka on 11/15/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var button: UIButton!
    
    @IBAction func btnAction(_ sender: Any) {
        UIView.transition(with: self.imageView,
                          duration: 0.8,
        options: .transitionCrossDissolve,
        animations: { self.imageView.image = UIImage(named: "travel") },
        completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

}
