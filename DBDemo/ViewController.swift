//
//  ViewController.swift
//  DBDemo
//
//  Created by Henry Doan on 7/12/21.
//

import UIKit
import SQLite3

class ViewController: UIViewController {

    var db: OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // the database file
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("HeroesDatabase.sqlite")
        
        // open db
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("err opening db")
        }
        
        // create table
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Heroes (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, powerrank INTEGER)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
    }


}

