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
    @IBOutlet var selector: UISegmentedControl!
    @IBOutlet var topView: UIView!
    
    var segmentIndex:Int = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableuxView.delegate = self
        tableuxView.dataSource = self
        tableuxView.tableFooterView = UIView()
        tableuxView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        customize()
        
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
        
//        let addItemBtnImage = UIImage(named: "new")
//        let addItemBtn = UIBarButtonItem()
//        addItemBtn.setBackgroundImage(addItemBtnImage, for: UIControl.State.normal, barMetrics: UIBarMetrics(rawValue: 0)!)
//
//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
//        navigationItem.rightBarButtonItem = addButton
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? DetailViewController
        }
            
    }
    
    @IBAction func indexControl(_ sender: Any) {
        if selector.selectedSegmentIndex == 0 {
            segmentIndex = 0
            tableView.reloadData()
        } else if selector.selectedSegmentIndex == 1 {
            segmentIndex = 1
            tableView.reloadData()
        } else if selector.selectedSegmentIndex == 2 {
            segmentIndex = 2
            tableView.reloadData()
        }
    }

//    override func viewWillAppear(_ animated: Bool) {
//        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
//        super.viewWillAppear(animated)
//    }

//    @objc
//    func insertNewObject(_ sender: Any) {
//        objects.insert(NSDate(), at: 0)
//        performSegue(withIdentifier: "showCreateNoteSegue", sender: self)
//    }

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
        cell.selectionStyle = .none
        cell.cellBar.layer.cornerRadius = 10
        
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
            
        } else if (segmentIndex == 2) {
            
            if let object = NoteStorage.storage.readNote(at: indexPath.row) {
                if !(object.actualDate < Date()) {
                    height = 0.0
                }
            }
            
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
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
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
