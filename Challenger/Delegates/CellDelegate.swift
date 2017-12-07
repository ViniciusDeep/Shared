//
//  CellDelegate.swift
//  Challenger
//
//  Created by João Luiz dos Santos Albuquerque on 06/12/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//

import UIKit

protocol CellDelegate: class {
    func didTapAccept(index: IndexPath)
    func didTapReject(index: IndexPath)
}
