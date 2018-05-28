//
//  ListTableViewController.swift
//  Checklist
//
//  Created by Thao Doan on 5/18/18.
//  Copyright © 2018 Thao Doan. All rights reserved.
//

import UIKit
import CoreData
class ListTableViewController: UITableViewController {

    let fetchResultController: NSFetchedResultsController<List> = {
        
        let fetchRequest : NSFetchRequest<List> = List.fetchRequest()
        
        let listSortDescriptor = NSSortDescriptor(key:"name", ascending: true)
        
        fetchRequest.sortDescriptors = [listSortDescriptor]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        fetchResultController.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        do {
          try fetchResultController.performFetch()
        } catch let error {
            print("Error performing fetch: \(error.localizedDescription)" )
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonTapp(_ sender: UIBarButtonItem) {
        addNewListAlertController()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchResultController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? ListTableViewCell
        
        guard let list = fetchResultController.fetchedObjects?[indexPath.row] else {return UITableViewCell()}
//        cell?.contentView.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        cell?.nameLabel.text = list.name
        cell?.toggleImage(isDone: list.isDone)
        cell?.delegate = self
        
        return cell ?? UITableViewCell()
    }
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            guard let index = fetchResultController.fetchedObjects?[indexPath.row] else {return}
            
             ListModelController.shared.detele(list: index)
           
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.4)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
         return "List Items "
    }
}

extension ListTableViewController : NSFetchedResultsControllerDelegate{
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        case .move: return
        }
    }
}

extension ListTableViewController {
    
    func addNewListAlertController() {
        
        var listTextField: UITextField?
        
        let alertController = UIAlertController(title: "Add New Check List ", message: "Enter Your Note", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter your note here"
            
            listTextField = textField
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let list = listTextField?.text else {return}
            
            ListModelController.shared.add(name: list)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        
        alertController.addAction(cancelAction)
        
        present(alertController,animated: true, completion: nil)
    }
    
}

extension ListTableViewController : ListCellDelegate {
    func cellButtonTapped(_ cell: ListTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            
            if let checkButtonTapped = fetchResultController.fetchedObjects?[indexPath.row] {
                
                ListModelController.shared.toggleCheckListButton(list: checkButtonTapped)
            }
        }
    }
    
    
}

extension ListTableViewController {
    func setUpUI() {
        let backgroundImage = UIImageView(image: #imageLiteral(resourceName: "lazer"))
        tableView.backgroundView = backgroundImage
        backgroundImage.contentMode = .scaleToFill
        
//        let customView = UIView()
//        customView.backgroundColor = .blue 
//        customView.clipsToBounds = true
//        customView.frame = CGRect(x: 315, y: 50, width: 50, height: 50)
//        customView.layer.cornerRadius = customView.layer.frame.height / 3
//        view.addSubview(customView)
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = backgroundImage.bounds
        
        backgroundImage.addSubview(blurView)
        blurView.clipsToBounds = true
        
        
        
        
    }
}
