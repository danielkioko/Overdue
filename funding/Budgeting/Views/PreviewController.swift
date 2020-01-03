//
//  PreviewController.swift
//  funding
//
//  Created by Daniel Nzioka on 1/2/20.
//  Copyright © 2020 Daniel Nzioka. All rights reserved.
//

import UIKit

class PreviewController: UIViewController {
    
    @IBOutlet var cardLayer: UIView!
    @IBOutlet var icon: UIView!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var costLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        customize()
    }
    
    var detailItem: SimpleNote? {
        didSet {
            // Update the view.
        }
    }
    
    func configureView() {
           if let detail = detailItem {
               if let topicLabel = titleLabel,
                let amountView = costLabel,
                let notesView = descriptionLabel {
                   topicLabel.text = detail.noteTitle
                amountView.text = detail.amount.currencyFormatting()
                notesView.text = detail.notes
               }
           }
    }
        
        
        func customize() {
            
            self.view.backgroundColor = UIColor.white
            
//            cardLayer.layer.cornerRadius = 20
//            cardLayer.layer.shadowColor = UIColor.black.cgColor
//            cardLayer.layer.shadowOffset = CGSize(width: 0, height: 5.0)
//            cardLayer.layer.shadowOpacity = 0.2
//            cardLayer.layer.shadowRadius = 4.0
//
//            icon.layer.cornerRadius = 20
//            icon.layer.shadowColor = UIColor.black.cgColor
//            icon.layer.shadowOffset = CGSize(width: 0, height: 5.0)
//            icon.layer.shadowOpacity = 0.2
//            icon.layer.shadowRadius = 4.0
//
//            doneButton.layer.cornerRadius = 20
//            doneButton.layer.shadowColor = UIColor.black.cgColor
//            doneButton.layer.shadowOffset = CGSize(width: 0, height: 5.0)
//            doneButton.layer.shadowOpacity = 0.2
//            doneButton.layer.shadowRadius = 4.0
    //
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
