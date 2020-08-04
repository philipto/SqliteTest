//
//  ViewController.swift
//  SqliteTest
//
//  Created by Philip Torchinsky on 4.8.2020.
//  Copyright © 2020 Keepdev. All rights reserved.
//

import UIKit
import SQLite

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var dataStore = DataStore()
        
        dataStore.start()
        

        // Do any additional setup after loading the view.
    }


}

