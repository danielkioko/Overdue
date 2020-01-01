//
//  MainViewController.swift
//  funding
//
//  Created by Daniel Nzioka on 12/20/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import UIKit
import Foundation

let billDueCellID = "billDueCell"

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var leCollectionView: UICollectionView!
    
    @IBOutlet var headerLayer: UIView!
    @IBOutlet var addBillLayer: UIView!
    @IBOutlet var preferencesLayer:UIView!
    @IBOutlet var upcomingText: UILabel!
    
    @IBOutlet var barOuterLayer: UIView!
    @IBOutlet var barInnerLayer: UIView!
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var remainingLabel: UILabel!
    
    var objects = [Any]()
    var itemsCount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customize()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            // create alert
            let alert = UIAlertController(
                title: "Could note get app delegate",
                message: "Could note get app delegate, unexpected error occurred. Try again later.",
                preferredStyle: .alert)
            
            // add OK action
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default))
            // show alert
            self.present(alert, animated: true)

            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        NoteStorage.storage.setManagedContext(managedObjectContext: context)
        
        let cell = UINib(nibName: "UpcomingViewCell", bundle: nil)
        leCollectionView.register(cell, forCellWithReuseIdentifier: billDueCellID)
        
        leCollectionView.reloadData()
        calculateTotal()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countOnlyUpcomingBills()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "billDueCell", for: indexPath) as! UpcomingViewCell
    
        let object = NoteStorage.storage.readNote(at: indexPath.row)
        
        if (object!.actualDate >= Date()) {
            
            cell.billName.text = object?.noteTitle
            cell.billAmount.text = object?.amount.currencyFormatting()
            let dueDate = object?.actualDate
            cell.billDueDate.text = "Due on " + (dueDate?.toString(dateFormat: "MM-dd"))!
            
        }
    
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        leCollectionView.reloadData()
        calculateTotal()
    }
    
    func calculateTotal() {
    
        var amounts: [Int] = []
        var total: Int = 0
        let budgetAmt = UserDefaults.standard.string(forKey: "budgetConstName")
        let budgetedAmount = Int(budgetAmt ?? "0")
            
        var i = 0
        var j = 0
        
        while (i < NoteStorage.storage.count()) {
                
                if let object = NoteStorage.storage.readNote(at: i){
                    if (object.actualDate >= Date()) {
                        amounts.append(Int(object.amount) ?? 0)
                    }
                }
                
                i += 1
                
            }
            
        while (j <= NoteStorage.storage.count()) {
            total = amounts.reduce(0, +)
            j += 1
        }
        
        totalLabel.text = String(total).currencyFormatting()
        remainingLabel.text = (String(budgetedAmount ?? 0 - total).currencyFormatting()) + " remaining"
        
        if (total == 0) {
            upcomingText.isHidden = true
        } else {
            upcomingText.isHidden = false
        }
        
//        let percentage = ((500000 - total) * 100) / total
//        updateBarChart(prc: percentage)
        
    }
    
    func updateBarChart(prc: Int) {
                
    }

    func countOnlyUpcomingBills() -> Int {
        
        var count = 0
        var i = 0
        
        while (i < NoteStorage.storage.count()) {
            
            let object = NoteStorage.storage.readNote(at: i)
            
            if (object!.actualDate >= Date()) {
                count += 1
            }
            
            i += 1
        }
        
        print(count)
        return count
        
    }
    
    func customize() {
        
        headerLayer.layer.cornerRadius = 20
        headerLayer.layer.shadowColor = UIColor.black.cgColor
        headerLayer.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        headerLayer.layer.shadowOpacity = 0.2
        headerLayer.layer.shadowRadius = 4.0
        
        addBillLayer.layer.cornerRadius = 20
        addBillLayer.layer.shadowColor = UIColor.black.cgColor
        addBillLayer.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        addBillLayer.layer.shadowOpacity = 0.2
        addBillLayer.layer.shadowRadius = 4.0
        
        preferencesLayer.layer.cornerRadius = 20
        preferencesLayer.layer.shadowColor = UIColor.black.cgColor
        preferencesLayer.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        preferencesLayer.layer.shadowOpacity = 0.2
        preferencesLayer.layer.shadowRadius = 4.0
        
//        barOuterLayer.layer.cornerRadius = 20
//        barOuterLayer.layer.shadowColor = UIColor.black.cgColor
//        barOuterLayer.layer.shadowOffset = CGSize(width: 0, height: 2.5)
//        barOuterLayer.layer.shadowOpacity = 0.2
//        barOuterLayer.layer.shadowRadius = 4.0
        
        
    }
    
}
