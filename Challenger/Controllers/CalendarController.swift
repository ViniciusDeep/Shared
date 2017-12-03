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
import SDWebImage
class CalendarController: UIViewController{
    var expandButtonClick : Int=0
    var actualDate : Date?
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var year: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var heightCalendarConst: NSLayoutConstraint! //275 initial 91 cell size
    @IBOutlet weak var heightTableConst: NSLayoutConstraint! // 185 initial
    
    @IBOutlet weak var expandButtonOutlet: UIButton!
    @IBOutlet weak var imageButtonOutlet: UIButton!
    @IBOutlet weak var archiveButtonOutlet: UIButton!
    @IBOutlet weak var textFieldOutlet: UITextField!
    @IBOutlet weak var sendButtonOutlet: UIButton!
    
    var thisCalendar = Calendar.current
    var dateSelected : Date?
    var group : Group? = nil
    var email : String?
    var archives : [Archive] = []
    let formatter = DateFormatter()
    var numberOfRows : Int?
    var generateInDates : InDateCellGeneration?
    var generateOutDates : OutDateCellGeneration?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = group?.name
        expandButtonOutlet.setImage(#imageLiteral(resourceName: "ic_expand_less"), for: UIControlState.normal)
        archiveButtonOutlet.isHidden=true
        let currentUser = Firebase.Auth.auth().currentUser
        email = currentUser?.email
        generateInDates = .forAllMonths
        generateOutDates = .tillEndOfGrid
        numberOfRows = nil
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        calendarView.scrollToDate(Date())
        setupCalendarView()
        calendarView.scrollingMode = .stopAtEachSection
        calendarView.visibleDates { (visibleDates) in
            self.setupViewOfCalendar(from: visibleDates)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        hiddenChat(hide: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? CalendarSettingsController {
            guard let index = sender as? Group else { return }
            controller.group = index
        }
        
        if let controller = segue.destination as? ShowImageController {
            guard let index = sender as? String else {
                print("in imageView")
                return
            }
            controller.archive = index
        }
        
    }
    //Buttons
    
    @IBAction func buttonSettings(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "CalendarSettings", sender: group)
    }
    @IBAction func buttonExpand(_ sender:   UIButton) {
        if(expandButtonClick == 0){
            numberOfRows = 1
            expandButtonOutlet.setImage(#imageLiteral(resourceName: "ic_expand_more"), for: UIControlState.normal)
            expandButtonOutlet.setTitle("Expand", for: UIControlState.normal)
            generateInDates = .forFirstMonthOnly
            generateOutDates = .off
            heightCalendarConst.constant = 91
            heightTableConst.constant = heightTableConst.constant + 184
            expandButtonClick = 1
        }else{
            heightCalendarConst.constant = 274
            heightTableConst.constant = heightTableConst.constant - 184
            numberOfRows = nil
            expandButtonOutlet.setImage(#imageLiteral(resourceName: "ic_expand_less"), for: UIControlState.normal)
             expandButtonOutlet.setTitle("Reduce", for: UIControlState.normal)
            generateInDates = .forAllMonths
            generateOutDates = .tillEndOfGrid
            expandButtonClick = 0
        }
        if(dateSelected != nil){
            calendarView.reloadData(){
                self.calendarView.scrollToDate(self.dateSelected!)
            }
        }else{
            calendarView.reloadData()
        }
    }
    @IBAction func buttonImageSend(_ sender: UIButton) {
        if(dateSelected != nil){
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func buttonTextSend(_ sender: UIButton) {
        if(textFieldOutlet.text != "" && dateSelected != nil){
            let timestamp = dateSelected?.timeIntervalSince1970
            let textFilesManager = FilesManager()
            let autoID = Database.database().reference().childByAutoId().key
            let newArchive = Archive(name: autoID,groupID: group?.key, date: timestamp, archive: self.textFieldOutlet.text!, type: "text")
            textFilesManager.uploadArchive(archive: newArchive)
            self.archives.append(newArchive)
            self.tableView.reloadData()
            textFieldOutlet.text = ""
        }else{
            
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    func isSameDay(dayOne: TimeInterval, dayTwo: TimeInterval) -> Bool{
        let dateOne = Date(timeIntervalSince1970: dayOne)
        let dateTwo = Date(timeIntervalSince1970: dayTwo)
        let calendar = Calendar.current
        let sameYear = calendar.component(.year, from: dateOne) == calendar.component(.year, from: dateTwo)
        let sameDay = calendar.component(.day, from: dateOne) == calendar.component(.day, from: dateTwo)
        let sameMonth = calendar.component(.month, from: dateOne) == calendar.component(.month, from: dateTwo)
        return  sameDay && sameYear && sameMonth
    }
    //Calendar Functions
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
            validCell.dayLabel.textColor = UIColor.white
        } else {
            let today = Date()
            formatter.dateFormat = "yyyy MM dd"
            let todayDateStr = formatter.string(from: today)
            formatter.dateFormat = "yyyy MM dd"
            let cellDateStr = formatter.string(from: cellState.date)
            //date right now is paint with yellow
            if todayDateStr == cellDateStr {
                validCell.dayLabel.textColor = UIColor.blue
                //month days are black and non-month days are lightGray
            } else {
                if cellState.dateBelongsTo == .thisMonth {
                    validCell.dayLabel.textColor = UIColor.black
                } else { //i.e. case it belongs to inDate or outDate
                    validCell.dayLabel.textColor = UIColor.lightGray
                }
            }
        }
    }
    func setupCalendarView(){
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
    }
    //Table Functions
    func populateTableView(date: Double, groupID : String) {
        if !archives.isEmpty {
            self.archives.removeAll()
            tableView.reloadData()
        }
        let ref = Database.database().reference()
        ref.child("archives/" + (group?.key)!).observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() {
                return
            }
            let snapshots = snapshot.children.allObjects.flatMap { $0 as? DataSnapshot }
            
            let keys = snapshots.map { $0.key }
            
            var archives = (snapshots.flatMap { Archive.deserialize(from: $0.value as? NSDictionary) })
                .enumerated()
                .flatMap { index, archive -> Archive in
                    archive.archiveID = keys[index]
                    return archive
            }
            self.archives = archives.filter { $0.groupID! == groupID && self.isSameDay(dayOne: $0.date ?? 0, dayTwo: date)}
            self.tableView.reloadData()
        })
    }
    
    
}
//Calendar extensions
extension CalendarController : JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! CustomCell
        cell.dayLabel.text = cellState.text
        
        handleCellSelected(cell: cell, cellState: cellState)
        handleCellTextColor(cell: cell, cellState: cellState)
    }
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
        dateSelected = date
        populateTableView(date: date.timeIntervalSince1970, groupID: (group?.key)!)
        
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
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: numberOfRows, calendar: thisCalendar, generateInDates: generateInDates, generateOutDates: generateOutDates, firstDayOfWeek: .monday, hasStrictBoundaries: true)
        return parameters
    }
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewOfCalendar(from: visibleDates)
    }
    
}
//Image Picker Extensions
extension CalendarController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        formatter.dateFormat = "yyyy mM dd"
//        formatter.timeZone = Calendar.current.timeZone
//        formatter.locale = Calendar.current.locale
        var imageUrl : String?
        let timestamp = dateSelected?.timeIntervalSince1970
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            let imagesFilesManager = FilesManager()
            imagesFilesManager.uploadImage(image, completionBlock: { (url,id, error) in
                print(url?.absoluteString)
                imageUrl = url?.absoluteString
                let newArchive = Archive(name: id,groupID: self.group?.key, date: timestamp, archive: imageUrl!, type: "jpeg")
                imagesFilesManager.uploadArchive(archive: newArchive)
                self.archives.append(newArchive)
                self.tableView.reloadData()
            })
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}
//Table extensions
extension CalendarController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let archive = archives[indexPath.row]
        switch(archive.type!){
        case "text":
            let cell = tableView.dequeueReusableCell(withIdentifier: "Comment", for: indexPath)
            cell.textLabel?.text = email! + ":"
            cell.detailTextLabel?.text = archive.archive
            
            return cell
        case "jpeg":
            let cell = tableView.dequeueReusableCell(withIdentifier: "Archive", for: indexPath) as? FileArchiveCell
            cell?.nameLabel.text = email! + ":"
            let url = URL(string: archives[indexPath.row].archive!)
            cell?.imageOutlet.sd_setImage(with: url ,completed: nil)
            return cell!
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let archive = archives[indexPath.row]
        switch(archive.type!){
        case "text":
            break
        case "jpeg":
            performSegue(withIdentifier: "ShowImage", sender: archives[indexPath.row].archive)
        default:
            break
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.archives.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let archive = archives[indexPath.row]
        switch(archive.type!){
        case "text":
            return 43.5
        case "jpeg":
            return 114.5
        default:
            return 44
        }
    }
}
