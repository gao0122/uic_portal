//
//  TodayViewController.swift
//  UIC Timetable
//
//  Created by 高宇超 on 7/20/17.
//  Copyright © 2017 Yuchao. All rights reserved.
//

import UIKit
import NotificationCenter
import RealmSwift

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Realm.Configuration.defaultConfiguration.fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.uicportal")?.appendingPathComponent("default.realm")


        
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        tableView.reloadData()
        
        completionHandler(NCUpdateResult.newData)

    }

    // MARK: TableView
    //
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
}


