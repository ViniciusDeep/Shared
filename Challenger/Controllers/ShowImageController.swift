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
    
    @IBOutlet weak var downloadButtonOutlet: UIBarButtonItem!
    
    
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
        downloadButtonOutlet.isEnabled = false
        downloadImage()
    }
    func downloadImage() {
        let reference = Storage.storage().reference(forURL: archive!)
        reference.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if (error != nil){
                print(error)
            }else {
                let myImage : UIImage! = UIImage(data: data!)
                UIImageWriteToSavedPhotosAlbum(myImage, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            if let error = error {
                // we got back an error!
                let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            } else {
                let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
                downloadButtonOutlet.isEnabled = true
            }
    }
}
