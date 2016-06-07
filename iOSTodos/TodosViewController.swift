//
//  AppDelegate.swift
//  CoreMemoApp
//
//  Created by kando on 2016/06/03.
//  Copyright © 2016年 skando. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift


//class TodosViewController: UITableViewController, NSFetchedResultsControllerDelegate {
class TodosViewController: UITableViewController {
  
  var detailViewController: TodoDetailsViewController? = nil
  let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
  var objects = [DateTimeLog]()
    
    /*
  lazy var fetchedResultController: NSFetchedResultsController = {
    guard let managedObjectContext = self.managedObjectContext else { return NSFetchedResultsController() }
    let fetchedResultController = NSFetchedResultsController(fetchRequest: self.todoFetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    fetchedResultController.delegate = self
    return fetchedResultController
  }()

  let todoFetchRequest: NSFetchRequest = {
    let fetchRequest = NSFetchRequest(entityName: "Todo")
    let sortDescriptor = NSSortDescriptor(key: "content", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    return fetchRequest
  }()
 */
    
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.leftBarButtonItem = self.editButtonItem()
    //let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(insertNewObject(_:)))
    //self.navigationItem.rightBarButtonItem = addButton
    
    let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
    self.navigationItem.rightBarButtonItem = addButton

    
    if let split = self.splitViewController {
      let controllers = split.viewControllers
      self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? TodoDetailsViewController
    }
  }
    
  //override func viewWillAppear(animated: Bool) {
  //self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
  //super.viewWillAppear(animated)
  //}
    
    
    func getRealmObject() -> [Todo]? {
        
        let realm = try! Realm()
        let memoArray = realm.objects(Todo)
        if memoArray.count == 0 {
            return nil
        }
        
        var realmObjects = [Todo]()
        for (index, dateTimeLog) in memoArray.enumerate() {
            realmObjects.insert(dateTimeLog, atIndex: index)
        }
        
        return realmObjects
    }
    
  func insertNewObject(sender: AnyObject) {
    let context = self.fetchedResultsController.managedObjectContext
    let entity = self.fetchedResultsController.fetchRequest.entity!
    //let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context)
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
   //newManagedObject.setValue(NSDate(), forKey: "timeStamp")
        
    // Save the context.
    //do {
      //try context.save()
    //} catch {
      // Replace this implementation with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      //print("Unresolved error \(error), \(error.userInfo)")
      //abort()
    //}
    
    let object = Todo()
    object.id = NSUUID().UUIDString
    
    objects.insert(object, atIndex: 0)
    let indexPath = NSIndexPath(forRow: 0, inSection: 0)
    self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    
    let realm = try! Realm()
    try! realm.write{
        realm.add(object)
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    switch segue.identifier {
      case .Some("Edit"):
        guard let cell = sender as? UITableViewCell else { return }
        guard let indexPath = self.tableView.indexPathForCell(cell) else { return }
        //let todo = self.fetchedResultController.objectAtIndexPath(indexPath) as? Todo
        let todo = self.tableView.indexPathForSelectedRow as! Todo
        let todoDetailsController = segue.destinationViewController as! TodoDetailsViewController
        todoDetailsController.todo = todo
      default: break
    }
  }

    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let date = objects[indexPath.row].date
        cell.textLabel!.text = date.description
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let object = objects[indexPath.row]
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            let realm = try! Realm()
            try! realm.write {
                realm.delete(object)
            }
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    
    /*
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let numberOfRowsInsection = self.fetchedResultController.sections?[section].numberOfObjects
    return numberOfRowsInsection ?? 0
  }
    
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let todo = self.fetchedResultController.objectAtIndexPath(indexPath) as? Todo else { fatalError("Todo is invalid") }
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
    cell.textLabel?.text = todo.content
    return cell
  }
    
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    guard let managedObject = self.fetchedResultController.objectAtIndexPath(indexPath) as? NSManagedObject else { return }
    self.managedObjectContext?.deleteObject(managedObject)
    do {
      try managedObjectContext?.save()
    } catch {
      managedObjectContext?.rollback()
    }
  }
 */

  //var fetchedResultsController: NSFetchedResultsController {
    //if _fetchedResultsController != nil {
      //return _fetchedResultsController!
    //}
        
    //let fetchRequest = NSFetchRequest()
    // Edit the entity name as appropriate.
    //let entity = NSEntityDescription.entityForName("Event", inManagedObjectContext: self.managedObjectContext!)
    //fetchRequest.entity = entity
        
    // Set the batch size to a suitable number.
    //fetchRequest.fetchBatchSize = 20
        
    // Edit the sort key as appropriate.
    //let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
    //fetchRequest.sortDescriptors = [sortDescriptor]
        
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    //let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
    //aFetchedResultsController.delegate = self
    //_fetchedResultsController = aFetchedResultsController
        
    //do {
      //try _fetchedResultsController!.performFetch()
    //} catch {
      // Replace this implementation with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      //print("Unresolved error \(error), \(error.userInfo)")
      //abort()
    //}
    //return _fetchedResultsController!
  //}
  //var _fetchedResultsController: NSFetchedResultsController? = nil
  //func controllerDidChangeContent(controller: NSFetchedResultsController) {
    //self.tableView.reloadData()
  //}
}
