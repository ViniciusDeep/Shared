//
//  CalendarController.swift
//  Challenger
//
//  Created by Yago Saboia Felix Frota on 22/11/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//

import Foundation
import JTAppleCalendar
import FirebaseAuth
import FirebaseDatabase
import Firebase
import FirebaseStorage

class CalendarController: UIViewController{
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var year: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imageButtonOutlet: UIButton!
    @IBOutlet weak var archiveButtonOutlet: UIButton!
    @IBOutlet weak var textFieldOutlet: UITextField!
    @IBOutlet weak var sendButtonOutlet: UIButton!
    
    var thisCalendar = Calendar.current
    var dateSelected = Date()

    var archives : [Archive] = []
    
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        calendarView.scrollingMode = .stopAtEachSection
        hiddenChat(hide: true)
        calendarView.visibleDates { (visibleDates) in
            self.setupViewOfCalendar(from: visibleDates)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //Buttons
    
    @IBAction func buttonImageSend(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func buttonTextSend(_ sender: UIButton) {
        if(textFieldOutlet.text != ""){
            var commentURL : String?
            let timestamp = dateSelected.timeIntervalSince1970
            let textFilesManager = FilesManager()
            textFilesManager.uploadComment(textFieldOutlet.text!, completionBlock: { (url,id, error) in
                print(url?.absoluteString)
                commentURL = url?.absoluteString
                let newArchive = Archive(name: id,groupID: "0", date: timestamp, archive: commentURL!, type: "text")
                textFilesManager.uploadArchive(archive: newArchive)
            })
            textFieldOutlet.text = ""
        }else{
            
        }
    }
    
    //Normal Functions
    func hiddenChat(hide: Bool){
        if(hide){
            tableView.isHidden = true
            imageButtonOutlet.isHidden = true
            archiveButtonOutlet.isHidden = true
            textFieldOutlet.isHidden = true
            sendButtonOutlet.isHidden = true
        }else{
            tableView.isHidden = false
            imageButtonOutlet.isHidden = false
            archiveButtonOutlet.isHidden = false
            textFieldOutlet.isHidden = false
            sendButtonOutlet.isHidden = false
        }
    }
    
    
    func setupViewOfCalendar(from visibleDates: DateSegmentInfo){
        let date = visibleDates.monthDates.first!.date
        formatter.dateFormat = "yyyy"
        year.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        month.text = formatter.string(from: date)
    }
   
    func handleCellSelected(cell: JTAppleCell?, cellState: CellState){
        guard let validCell = cell as? CustomCell else { return }
        if validCell.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }
    
    func handleCellTextColor(cell: JTAppleCell?, cellState: CellState){
        guard let validCell = cell as? CustomCell else { return }
        //the date selected becomes yellow
        if validCell.isSelected {
            validCell.dayLabel.textColor = UIColor.yellow
        } else {
            let today = Date()
            formatter.dateFormat = "yyyy MM dd"
            let todayDateStr = formatter.string(from: today)
            formatter.dateFormat = "yyyy MM dd"
            let cellDateStr = formatter.string(from: cellState.date)
            //date right now is paint with yellow
            if todayDateStr == cellDateStr {
                validCell.dayLabel.textColor = UIColor.yellow
                //month days are white and non-month days are gray
            } else {
                if cellState.dateBelongsTo == .thisMonth {
                    validCell.dayLabel.textColor = UIColor.white
                } else { //i.e. case it belongs to inDate or outDate
                    validCell.dayLabel.textColor = UIColor.gray
                }
            }
        }
    }
    func setupCalendarView(){
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
    }
    
    
}
//Calendar extension
extension CalendarController : JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! CustomCell
        cell.dayLabel.text = cellState.text
        
        handleCellSelected(cell: cell, cellState: cellState)
        handleCellTextColor(cell: cell, cellState: cellState)
    }
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        print(cellState.dateBelongsTo)
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
        dateSelected = date
        
        hiddenChat(hide: false)
    }
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        print(cellState.dateBelongsTo)
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
        hiddenChat(hide: true)
    }
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dayLabel.text = cellState.text
        
        
        handleCellSelected(cell: cell, cellState: cellState)
        handleCellTextColor(cell: cell, cellState: cellState)
        return cell
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2018 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: nil, calendar: thisCalendar, generateInDates: .forAllMonths, generateOutDates: .tillEndOfGrid, firstDayOfWeek: .monday, hasStrictBoundaries: true)
        return parameters
    }
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewOfCalendar(from: visibleDates)
    }
    
}
//IMAGE PICKER EXTENSION
extension CalendarController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        formatter.dateFormat = "yyyy mM dd"
//        formatter.timeZone = Calendar.current.timeZone
//        formatter.locale = Calendar.current.locale
        var imageUrl : String?
        let timestamp = dateSelected.timeIntervalSince1970
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            let imagesFilesManager = FilesManager()
            imagesFilesManager.uploadImage(image, completionBlock: { (url,id, error) in
                print(url?.absoluteString)
                imageUrl = url?.absoluteString
                let newArchive = Archive(name: id,groupID: "0", date: timestamp, archive: imageUrl!, type: "jpeg")
                imagesFilesManager.uploadArchive(archive: newArchive)
            })
        }
        
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CalendarController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let archive = archives[indexPath.row]
        switch(archive.type!){
        case "Comment":
            let cell = tableView.dequeueReusableCell(withIdentifier: "Comment", for: indexPath) as? FileArchiveCell
            cell?.textLabel?.text = archive.archive
            return cell!
        case "png":
            let cell = tableView.dequeueReusableCell(withIdentifier: "Archive", for: indexPath) as? FileArchiveCell
            cell?.archiveLabel.text = archive.name
            return cell!
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return archives.count
    }
}
