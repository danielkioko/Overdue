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
    let shapeLayer = CAShapeLayer()
        
    @IBOutlet var headerLayer: UIView!
    @IBOutlet var addBillLayer: UIView!
    @IBOutlet var preferencesLayer:UIView!
    @IBOutlet var upcomingText: UILabel!
    @IBOutlet var progressBar: UIProgressView!
    
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
        
        leCollectionView.reloadData()
        calculateTotal()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countOnlyUpcomingBills()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ubCell", for: indexPath) as! UpcomingCell
    
        let object = NoteStorage.storage.readNote(at: indexPath.row)
        
        if (object!.actualDate >= Date()) {
            
            cell.billName.text = object?.noteTitle
            cell.billAmount.text = object?.amount.currencyFormatting()
            let dueDate = object?.actualDate
            cell.billDueDate.text = "Due on " + (dueDate?.toString(dateFormat: "MM-dd"))!
            
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil){ action in
            
            let viewMenu = UIAction(title: "View", image: UIImage(systemName: "eye.fill"), identifier: UIAction.Identifier(rawValue: "view")) {_ in
                print("button clicked..")
            }
            
            let rotate = UIAction(title: "Rotate", image: UIImage(systemName: "arrow.counterclockwise"), identifier: nil, state: .on, handler: {action in
                print("rotate clicked.")
            })
            
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash.fill"), identifier: nil, discoverabilityTitle: nil, attributes: .destructive, state: .on, handler: {action in
                
                print("delete clicked.")
            })
            
            let editMenu = UIMenu(title: "Edit...", children: [rotate, delete])
            
            
            return UIMenu(title: "Options", image: nil, identifier: nil, children: [viewMenu, editMenu])
        }
        
        return configuration
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        leCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        leCollectionView.reloadData()
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
        remainingLabel.text = (String(budgetedAmount!  - total).currencyFormatting()) + " remaining"
        
        if (total == 0) {
            upcomingText.isHidden = true
        } else {
            upcomingText.isHidden = false
        }
        
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
    
    @IBAction func doneBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func customize() {
        
        UIScrollView().isScrollEnabled = true
        UIScrollView().alwaysBounceVertical = true
        
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
        
        self.tabBarController?.tabBar.shadowImage = UIImage()
        self.tabBarController?.tabBar.backgroundImage = UIImage()
        self.tabBarController?.tabBar.clipsToBounds = true
        
    }

    
}
