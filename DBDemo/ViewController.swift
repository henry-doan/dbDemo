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
    
    @IBOutlet weak var HeroNameTextField: UITextField!
    @IBOutlet weak var PowerRankTextField: UITextField!
    
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
    
    @IBAction func SaveClick(_ sender: Any) {
        // grab text vals
        let heroName = HeroNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let powerRanking = PowerRankTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // make sure not empty
        if (heroName?.isEmpty)! {
            HeroNameTextField.layer.borderColor = UIColor.red.cgColor
            return
        }
        
        if (powerRanking?.isEmpty)! {
            PowerRankTextField.layer.borderColor = UIColor.red.cgColor
            return
        }
        
        // create a statement
        var stmt: OpaquePointer?
        
        // insert query
        let queryString = "INSERT INTO Heroes (name, powerrank) VALUES (?,?)"
        
        // prep the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        // binding the params
        if sqlite3_bind_text(stmt, 1, heroName, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("fail binding Hero Name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_int(stmt, 2, (powerRanking! as NSString).intValue) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("fail binding PowerRank: \(errmsg)")
            return
        }
        
        // executing the insert query
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure inserting hero: \(errmsg)")
            return
        }
        
        // empty the textfields
        HeroNameTextField.text = ""
        PowerRankTextField.text = ""
        
        
//       readValues()
        
        // displaying a success msg
        print("Hero successfully saved")
        
    }


}

