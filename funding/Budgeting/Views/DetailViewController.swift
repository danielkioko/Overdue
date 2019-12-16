//
//  DetailViewController.swift
//  funding
//
//  Created by Daniel Nzioka on 10/18/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteAmountView: UILabel!
    @IBOutlet weak var noteTypeView: UILabel!
    @IBOutlet weak var noteDateLabel: UILabel!
    @IBOutlet weak var notesText: UITextView!
    @IBOutlet weak var labelToDueDate: UILabel!
    @IBOutlet weak var categoryCount: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet var editBtn: UIButton!
    @IBOutlet var ebLayer: UIView!
    
    let shapeLayer = CAShapeLayer()

    func configureView() {
       if let detail = detailItem {
           if let topicLabel = noteTitleLabel,
              let dateLabel = noteDateLabel,
              let typeLabel = noteTypeView,
              let notesView = notesText,
              let textView = noteAmountView {
               topicLabel.text = detail.noteTitle
            typeLabel.text = detail.noteType
            textView.text = detail.amount.currencyFormatting()
            notesView.text = detail.notes
            
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            let dateString: String = df.string(from: detail.actualDate)
            dateLabel.text = "Due on: " + String(dateString)
                
           }
       }
    }
    
    func loadCardView() {
        cardView.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cardView.layer.cornerRadius = 4
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.layer.masksToBounds = true
        cardView.layer.borderWidth = 0.0
        cardView.layer.shadowRadius = 2
        cardView.layer.shadowPath = UIBezierPath(roundedRect: cardView.layer.bounds, cornerRadius:         cardView.layer.cornerRadius).cgPath
        cardView.layer.masksToBounds = false
        cardView.layer.backgroundColor = UIColor.white.cgColor
        
    }
    
   override func viewDidLoad() {
       super.viewDidLoad()
       // Do any additional setup after loading the view, typically from a nib.
    self.navigationController?.title = ""
    customizeButtons()
    loadCardView()
    configureView()
    daysToDueDate()
    countItemsInCategory()
   }

   var detailItem: SimpleNote? {
       didSet {
           // Update the view.
       }
   }

   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "showChangeNoteSegue" {
           let changeNoteViewController = segue.destination as! CreateChange
           if let detail = detailItem {
               changeNoteViewController.setChangingReallySimpleNote(
                   changingReallySimpleNote: detail)
           }
       }
   }


}

