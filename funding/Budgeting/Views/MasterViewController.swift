//
//  MasterViewController.swift
//  funding
//
//  Created by Daniel Nzioka on 10/18/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import UIKit
import Foundation

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    
    @IBOutlet var tableuxView: UITableView!
    
    var objects = [Any]()
    @IBOutlet var totalLayer: UIView!
    
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var selector: UISegmentedControl!
    @IBOutlet var topView: UIView!
    @IBOutlet var dueLabel: UILabel!
    
    var segmentIndex:Int = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableuxView.delegate = self
        tableuxView.dataSource = self
        
        tableuxView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        self.navigationItem.title = ""
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.hidesBackButton = true
        
        // Core data initialization
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
        
        // As we know that container is set up in the AppDelegates so we need to refer that container.
        // We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // set context in the storage
        NoteStorage.storage.setManagedContext(managedObjectContext: managedContext)
        
        // Do any additional setup after loading the view, typically from a nib.
        //navigationItem.leftBarButtonItem = editButtonItem
        
        let addItemBtnImage = UIImage(named: "new")
        let addItemBtn = UIBarButtonItem()
        addItemBtn.setBackgroundImage(addItemBtnImage, for: UIControl.State.normal, barMetrics: UIBarMetrics(rawValue: 0)!)

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        customize()
        calculateTotal()
        
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willCommitWithAnimator animator: UIContextMenuInteractionCommitAnimating) {
        animator.addCompletion {
            self.show(MasterViewController(), sender: self)
        }
    }
    
//    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
//        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
//            return self.makeContextMenu()
//        })
//    }
    
    func makeContextMenu() -> UIMenu {

        let edit = UIAction(title: "Edit", image: UIImage(systemName: "square.and.arrow.up")) { action in

        }

        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: "someAction")
        //navigationItem.leftBarButtonItem = button

        return UIMenu(title: "edit", image: UIImage(named: "delete"))

    }
    
    
    @IBAction func indexControl(_ sender: Any) {
        if selector.selectedSegmentIndex == 0 {
            segmentIndex = 0
            tableView.reloadData()
            calculateTotal()
        } else if selector.selectedSegmentIndex == 1 {
            segmentIndex = 1
            tableView.reloadData()
            calculateTotal()
        } else if selector.selectedSegmentIndex == 2 {
            segmentIndex = 2
            tableView.reloadData()
            calculateTotal()
        }
    }
    
    func calculateTotal() {
        
        if (selector.selectedSegmentIndex == 0) {
            var amounts: [Int] = []
            var total: Int = 0
            
            var i = 0
            var j = 0
            
            while (i < NoteStorage.storage.count()) {
                    
                    if let object = NoteStorage.storage.readNote(at: i){
                        amounts.append(Int(object.amount) ?? 0)
                    }
                    
                    i += 1
                    
                }
                
                while (j <= NoteStorage.storage.count()) {
                    total = amounts.reduce(0, +)
                    j += 1
                }
                
                totalLabel.text = String(total).currencyFormatting()
        } else if (selector.selectedSegmentIndex == 1) {
            calculateUpcomingDues()
        } else if (selector.selectedSegmentIndex == 2) {
            calculateOverDues()
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    @objc
    func insertNewObject(_ sender: Any) {
        objects.insert(NSDate(), at: 0)
        performSegue(withIdentifier: "showCreateNoteSegue", sender: self)
    }

    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                //let object = objects[indexPath.row]
                let object = NoteStorage.storage.readNote(at: indexPath.row)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NoteStorage.storage.count()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NoteTableViewCell
        
        if let object = NoteStorage.storage.readNote(at: indexPath.row) {
            cell.noteTitleLabel!.text = object.noteTitle
            let dueDate:Date = object.actualDate
            cell.noteDateLabel!.text = dueDate.toString(dateFormat: "MM-dd-yyyy")
            
            let result = calculateDaysBetweenTwoDates(start: Date(), end: object.actualDate)
            
            if (result == 0) {
                cell.noteAmountLabel!.text = object.amount.currencyFormatting()
                cell.daysLeftToDueDateLabel!.text = String(result)
            } else if (result == 1) {
                cell.noteAmountLabel!.text = object.amount.currencyFormatting()
                cell.daysLeftToDueDateLabel!.text = String(result)
            } else if (result < 0) {
                cell.noteAmountLabel!.text = object.amount.currencyFormatting()
                cell.daysLeftToDueDateLabel!.text = String(result)
            } else {
                cell.noteAmountLabel!.text = object.amount.currencyFormatting()
                cell.daysLeftToDueDateLabel!.text = String(result)
            }
            
        }
        
        cell.cellView.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.cellView.layer.cornerRadius = 4
        cell.cellBar.layer.cornerRadius = 4
        cell.cellView.layer.borderWidth = 0.0
        cell.cellView.layer.masksToBounds = true
        cell.cellView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.cellView.layer.shadowColor = #colorLiteral(red: 0.2156862745, green: 0.3294117647, blue: 0.6666666667, alpha: 1)
        cell.cellView.layer.shadowRadius = 2
        cell.cellView.layer.shadowOpacity = 0.2
        cell.cellView.layer.masksToBounds = false
        cell.cellView.layer.shadowPath = UIBezierPath(roundedRect: cell.cellView.bounds, cornerRadius:         cell.cellView.layer.cornerRadius).cgPath
         
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height: CGFloat = 110.0
        
        if (segmentIndex == 1) {
            
            if let object = NoteStorage.storage.readNote(at: indexPath.row) {
                if !(object.actualDate > Date()) {
                    height = 0.0
                    tableView.cellForRow(at: indexPath)?.isHidden = true
                }
            }

//            if let object = NoteStorage.storage.readNote(at: indexPath.row) {
//                let today = Date()
//                let pastWeekDate = getCurrentWeekItems(date: Date())
//                if (!(pastWeekDate...today ~= object.actualDate)) {
//                    height = 0.0
//                }
//            }
            
        } else if (segmentIndex == 2) {
            
            if let object = NoteStorage.storage.readNote(at: indexPath.row) {
                if !(object.actualDate < Date()) {
                    height = 0.0
                }
            }
            
//            if let object = NoteStorage.storage.readNote(at: indexPath.row) {
//                let today = Date()
//                let pastMonthDate = getCurrentMonthItems(date: Date())
//                if (!(pastMonthDate...today ~= object.actualDate)) {
//                    height = 0.0
//                }
//            }
            
        } else if (segmentIndex == 0) {
            height = 110.0
        }
        
        return height
        
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NoteTableViewCell
    
        if editingStyle == .delete {
            //objects.remove(at: indexPath.row)
            NoteStorage.storage.removeNote(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            cell.cellView.layer.shadowColor = UIColor.white.cgColor
            
        } else if editingStyle == .insert {
            
             cell.cellView.layer.shadowColor = UIColor.white.cgColor
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
}

func calculateDaysBetweenTwoDates(start: Date, end: Date) -> Int {

    let currentCalendar = Calendar.current
    guard let start = currentCalendar.ordinality(of: .day, in: .era, for: start) else {
        return 0
    }
    guard let end = currentCalendar.ordinality(of: .day, in: .era, for: end) else {
        return 0
    }
    return end - start
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}

extension UIView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds

        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
    
}
