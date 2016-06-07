//
//  AppDelegate.swift
//  CoreMemoApp
//
//  Created by kando on 2016/06/03.
//  Copyright © 2016年 skando. All rights reserved.
//

import UIKit
import CoreData

class TodoDetailsViewController: UITableViewController, UITextFieldDelegate, NSFetchedResultsControllerDelegate {
    
    let ENTITY_NAME = "Memo"
    let ITEM_NAME = "text"
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
  var todo: Todo?

  @IBOutlet weak var textField: UITextField!
    
  @IBAction func save(sender: AnyObject) {
    if let _ = self.todo {
      self.editTodo()
    } else {
      self.createTodo()
    }
  }

  @IBAction func cancel(sender: AnyObject) {
    self.dismissViewController()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.textField.delegate = self
      if let todo = self.todo {
        self.textField.text = todo.content
      }
    }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
  }

  private func dismissViewController() {
    self.navigationController?.popViewControllerAnimated(true)
  }
    
  private func showAlert(message: String?) {
    let alertController = UIAlertController(title: "Error", message: (message ?? ""), preferredStyle: .Alert)
    let dafaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
    alertController.addAction(dafaultAction)
    self.presentViewController(alertController, animated: true, completion: nil)
  }
    
  private func saveTodo() {
    do {
      try self.managedObjectContext?.save()
      self.dismissViewController()
    } catch let error as NSError {
      self.showAlert(error.localizedDescription)
      self.managedObjectContext?.rollback()
    }
  }
     
 /*  func saveTodo() {
        /* Get ManagedObjectContext from AppDelegate */
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext: NSManagedObjectContext = appDelegate.managedObjectContext!
        
        /* Create new ManagedObject */
        let entity = NSEntityDescription.entityForName("Todo", inManagedObjectContext: managedContext)
        let personObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        /* Set the name attribute using key-value coding */
        personObject.setValue(todo, forKey: "contents")
     } */
    
  private func createTodo() {
    guard let managedObjectContext = self.managedObjectContext else { return }
    guard let text = self.textField.text else { return }

    let entity = NSEntityDescription.entityForName("Todo", inManagedObjectContext: managedObjectContext)
    let todo = Todo(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
    todo.content = text
    self.saveTodo()
  }
    
  private func editTodo() {
    guard let todo = self.todo, let text = self.textField.text else { return }
    todo.content = text
    self.saveTodo()
  }

}

