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
    
    func fillData() {
        if detailItem != nil {
            let detail = detailItem
            noteTitleLabel.text = detail!.noteTitle
            noteAmountView.text = detail!.amount.currencyFormatting()
            noteTypeView.text = detail!.noteType
            noteDateLabel.text = detail!.actualDate.toString()
        }
    }
    
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
        
        cardView.layer.cornerRadius = 20
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowRadius = 4.0
        
    }
    
   override func viewDidLoad() {
       super.viewDidLoad()
       // Do any additional setup after loading the view, typically from a nib.
    self.navigationController?.title = ""
//    customizeButtons()
//    loadCardView()
//    daysToDueDate()
//    countItemsInCategory()
//    configureView()
    fillData()
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

