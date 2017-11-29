//
//  FileArchiveCell.swift
//  Challenger
//
//  Created by Yago Saboia Felix Frota on 28/11/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//

import UIKit

class FileArchiveCell: UITableViewCell {

    
    
    @IBOutlet weak var archiveLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func buttonDownload(_ sender: UIButton) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
