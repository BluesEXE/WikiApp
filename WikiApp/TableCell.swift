//
//  TableCell.swift
//  WikiApp
//
//  Created by Danny Ho on 2015-06-08.
//  Copyright (c) 2015 Danny Ho. All rights reserved.
//

import Foundation
import UIKit

class TableCell: UITableViewCell {
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    @IBAction func favButtonSelected(sender: AnyObject) {
        if favButton.selected == true {
            favButton.selected = false
        } else {
            favButton.selected = true
        }
    }
    

    @IBAction func favButtonHighlight(sender: AnyObject) {
        favButton.highlighted = true
    }
}