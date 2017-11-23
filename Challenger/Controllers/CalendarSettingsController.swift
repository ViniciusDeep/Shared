//
//  CalendarSettingsController.swift
//  Challenger
//
//  Created by Yago Saboia Felix Frota on 22/11/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//
import UIKit
import Foundation

class CalendarSettingsController: UIViewController {
    
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    @IBOutlet weak var groupTableViewCell: UITableViewCell!
    
    @IBOutlet weak var functionsTableViewCell: UITableViewCell!
    
    
    @IBOutlet weak var leaveTableViewCell: UITableViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
