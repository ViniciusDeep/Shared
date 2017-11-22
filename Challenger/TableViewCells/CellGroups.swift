//
//  CellGroups.swift
//  Challenger
//
//  Created by João Luiz dos Santos Albuquerque on 16/11/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//

import UIKit

class CellGroups: UITableViewCell {

    @IBOutlet weak var imageGroup: UIImageView!
    
    @IBOutlet weak var nameGroup: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageGroup.layer.cornerRadius =
        self.imageGroup.frame.size.width / 2
        self.imageGroup.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
