//
//  CustomTableViewCell.swift
//  WBSwipeToOptionCell
//
//  Created by MacBook on 4/14/18.
//  Copyright © 2018 Waqas Bhati. All rights reserved.
//

import Foundation
import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if let optionView = self.viewWithTag(-1) as? MenuView {
            if optionView.menuOpen {
                optionView.close(withAnimation: true)
            }
        }
    }
}

