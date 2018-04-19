//
//  ViewController.swift
//  WBSwipeToOptionCell
//
//  Created by MacBook on 4/13/18.
//  Copyright © 2018 Waqas Sultan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var items: [WBMenuView]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      //  tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = 90.0
        
    }
    @objc func moreBtnPressed(sender: UIButton) {
        
        for (_, cell) in tableView.visibleCells.enumerated() {
            if let optionView = cell.viewWithTag(-1) as? WBMenuView {
                if optionView.isMenuOpen {
                    optionView.close()
                }
            }
        }
        if let optionView = sender.superview?.superview?.viewWithTag(-1) as? WBMenuView {
            if optionView.isMenuOpen {
                optionView.close()
            } else {
                optionView.open()
            }
        }
        
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CustomTableViewCell else {
            return UITableViewCell()
        }
        let item1 = WBMenuItem(title: "Delete", icon: "hello") { (item) in
            
        }
        item1.backgroundColor = UIColor.blue
        let item2 = WBMenuItem(title: "Submit", icon: "hello"){ (item) in
            
        }
        item2.backgroundColor = UIColor.green
        let item3 = WBMenuItem(title: "Save", icon: "hello"){ (item) in
            
        }
        item3.backgroundColor = UIColor.yellow
       // WBMenuView.addOptionsView(tableViewCell: cell, [item1, item2, item3])
        let menu = WBMenuView(tableViewCell:cell , items: [item1, item2, item3])
        menu.tag = -1
        cell.buttonMore.tag = indexPath.row
        cell.selectionStyle = .none
        cell.labelTitle.text = "sddfgsdfg"
        cell.buttonMore.addTarget(self, action: #selector(moreBtnPressed(sender:)), for: .touchUpInside)
        return cell
    }
}

