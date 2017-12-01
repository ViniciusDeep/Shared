//
//  ShowImageController.swift
//  Challenger
//
//  Created by Yago Saboia Felix Frota on 01/12/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseStorage
import Firebase
import FirebaseCore
import FirebaseDatabase
class ShowImageController: UIViewController {
    var archive : String?
    @IBOutlet weak var ImageOutlet: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: archive!)
        ImageOutlet.sd_setImage(with: url, completed: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func goBackButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func downloadButton(_ sender: UIBarButtonItem) {
        downloadImage()
    }
    func downloadImage() {
        let reference = Storage.storage().reference(forURL: archive!)
        reference.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if (error != nil){
                print(error)
            }else {
                let myImage : UIImage! = UIImage(data: data!)
                UIImageWriteToSavedPhotosAlbum(myImage, nil, nil, nil)
            }
        }
        
//        storageRef.downloadURL { (url, error) in
//            guard let imageURL = url, error == nil else{
//                return
//            }
//            guard let data = NSData(contentsOf: imageURL) else {
//                return
//            }
//            let image = UIImage(data: data as Data)
//
//        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
