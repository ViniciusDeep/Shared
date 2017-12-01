//
//  CalendarSettingsController.swift
//  Challenger
//
//  Created by Yago Saboia Felix Frota on 22/11/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//
import UIKit
import Foundation

class CalendarSettingsController: UITableViewController{
    
    @IBOutlet weak var groupImage: UIButton!
    @IBOutlet weak var groupName: UILabel!
    var group : Group? = nil
    
    
    @IBOutlet var settingsTableCalendarView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Settings"
        groupName.text = group?.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func changeimage(_ sender: UIButton) {
        let imagepicker = UIImagePickerController()
        imagepicker.allowsEditing = true
        imagepicker.sourceType = .photoLibrary
        imagepicker.delegate = self
        
        self.present(imagepicker, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return CGFloat.leastNormalMagnitude
        }
        return CGFloat.init(3)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            if indexPath.row == 0 {
                print("teste")
            }
            if indexPath.row == 1 {
                print("teste2")
            }
        }
    }
    
    
    
}
extension CalendarSettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        //tirar isso dpos
        groupImage.setTitle("", for: UIControlState.normal)
        groupImage.setBackgroundImage(image, for: UIControlState.normal)
        picker.dismiss(animated: true, completion: nil)
        
        
        
    }
}
