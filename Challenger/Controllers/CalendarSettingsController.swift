//
//  CalendarSettingsController.swift
//  Challenger
//
//  Created by Yago Saboia Felix Frota on 22/11/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//
import UIKit
import Foundation

class CalendarSettingsController: UITableViewController {
    
  
    @IBOutlet var settingsTableCalendarView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Settings"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return CGFloat.leastNormalMagnitude
        }
        return CGFloat.init(3)
    }
}
