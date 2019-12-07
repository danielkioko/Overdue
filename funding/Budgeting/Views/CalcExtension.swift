//
//  CalcExtension.swift
//  funding
//
//  Created by Daniel Nzioka on 11/30/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import Foundation
import UIKit

extension CalculatorController {
    
    func customize() {
        eraseLayer.layer.cornerRadius = 8
        createLayer.layer.cornerRadius = 8
        cardBackground.layer.cornerRadius = 18
        cardBackground.layer.borderWidth = 0.0
    }
    
}
