//
//  RequestsCell.swift
//  Challenger
//
//  Created by João Luiz dos Santos Albuquerque on 06/12/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//

import UIKit

class RequestsCell: UITableViewCell {

    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    var indexPath : IndexPath?
    var delegateCell : CellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func rejectAction(_ sender: Any) {
        delegateCell?.didTapReject(index: indexPath!)
    }
    
   
    @IBAction func acceptAction(_ sender: Any) {
        delegateCell?.didTapAccept(index: indexPath!)
    }
}
