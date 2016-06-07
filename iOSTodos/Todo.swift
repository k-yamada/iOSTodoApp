//
//  AppDelegate.swift
//  CoreMemoApp
//
//  Created by kando on 2016/06/03.
//  Copyright © 2016年 skando. All rights reserved.
//

import Foundation
//import CoreData
import RealmSwift

//class Todo: NSManagedObject {
class Todo: Object {
    //@NSManaged var content: String
    
  //func validateContent(ioValue: AutoreleasingUnsafeMutablePointer<AnyObject?>) throws {
    //let error = NSError(domain: "Migrator", code: 0, userInfo: nil)
    //if let content = ioValue.memory as? String {
      //if content.isEmpty {
        //print("Content is empty...")
        //throw error
      //}
    //} else {
      //print("Content is nil...")
      //throw error
    //}
    //}
    dynamic var id = ""
    dynamic var date = NSDate()
    dynamic var content: String = ""
    
    static var maxId = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
