//
//  ShowImageController.swift
//  Challenger
//
//  Created by Yago Saboia Felix Frota on 01/12/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//

import UIKit
import SDWebImage
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
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent("\(ImageOutlet).png")
            if let pngImageData = UIImagePNGRepresentation(ImageOutlet.image!) {
                try pngImageData.write(to: fileURL, options: .atomic)
            }
        } catch {
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
