//
//  CustomTableViewCell.swift
//  WBSwipeToOptionCell
//
//  Created by MacBook on 4/14/18.
//  Copyright © 2018 Waqas Sultan. All rights reserved.
//

import Foundation
import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonMore: UIButton!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if let optionView = self.viewWithTag(-1) as? WBMenuView {
            if optionView.isMenuOpen {
                optionView.close()
            }
        }
    }
}

