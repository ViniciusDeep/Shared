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
    
    @IBOutlet weak var imageView: UIImageView!
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
        let url = URL(string: (group?.image)!)
        imageView.sd_setImage(with: url, completed: nil)
        self.imageView.layer.cornerRadius =
            self.imageView.frame.size.width / 20
        self.imageView.layer.masksToBounds = true
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nav = segue.destination as? UINavigationController else {
            return
        }
        if let controller = nav.topViewController as? CalendarMemberController {
            controller.group = self.group
        }
        if let controller = nav.topViewController as? CalendarInviteController{
            controller.group = self.group
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
extension CalendarSettingsController {
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return CGFloat.leastNormalMagnitude
        }
        return CGFloat.init(3)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let identifier = tableView.cellForRow(at: indexPath)?.reuseIdentifier else {
            return
    }
        if identifier == "showMembers" {
            performSegue(withIdentifier: "showMembers", sender: nil)
        }
        if identifier == "calendarRequests"{
            performSegue(withIdentifier: "calendarInvites", sender: nil)
        }
}
}
