//
//  DataStore.swift
//  SqliteTest
//
//  Created by Philip Torchinsky on 4.8.2020.
//  Copyright © 2020 Keepdev. All rights reserved.
//

import Foundation
import SQLite

struct DataStore {
    var tasks = Table("tasks")
    var db: Connection!
    
    
    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
    ).first!
    
    let id = Expression<Int>("id")
    let title = Expression<String?>("title")
    let isactive = Expression<Bool?>("isactive")
    let timespent = Expression<Int?>("timespent")
    
    
    mutating func start() {
        do {
            db = try Connection("\(path)/db.sqlite3")
        } catch {
            print("connection failed")
        }
        
        do {
            try db.run(tasks.delete())
        } catch {
            print("delete failed")
        }
        
        do {
            try db.run(tasks.create(ifNotExists: true) { t in     // CREATE TABLE "users" IF NOT EXISTS (
                t.column(id, primaryKey: true) //     "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                t.column(title, unique: false)  //     "title" TEXT,
                t.column(isactive)                 //     "isactive" BOOLEAN
                t.column(timespent)                 // timespent INT
            })
            print("database created")
        } catch {
            print ("database not created")
        }
        
        do {
            try db.run(tasks.insert(id <- 0, title <- "iOS", isactive <- false, timespent <- 0))
            try db.run(tasks.insert(id <- 1, title <- "Suomi kieli", isactive <- false, timespent <- 0))
            try db.run(tasks.insert(id <- 2, title <- "Veneloma", isactive <- false, timespent <- 0))
            try db.run(tasks.insert(id <- 3, title <- "GitHub coop", isactive <- false, timespent <- 0))
            try db.run(tasks.insert(id <- 4, title <- "Regional search", isactive <- false, timespent <- 0))
            print("rows inserted")
        } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
            print("constraint failed: \(message), in \(String(describing: statement))")
        } catch let error {
            print("insertion failed: \(error)")
        }
        
        
        let query = tasks.select(id, title)
        do {
            for task in try db.prepare(query) {
                print(task[id], task[title] ?? "")
            }
        } catch {
            print("error")
        }
    }
}
