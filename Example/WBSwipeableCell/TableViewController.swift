//
//  ViewController.swift
//  WBSwipeToOptionCell
//
//  Created by MacBook on 4/13/18.
//  Copyright © 2018 Waqas Bhati. All rights reserved.
//

import UIKit
import WBSwipeableCell

class TableViewController: UIViewController {

    //MARK:- Instance Variables
    
    @IBOutlet weak var tableView: UITableView!
    private var items: [MenuView]?
    private var menuLayout: MenuLayout?
    private var menuDirection: Direction?

    //MARK:- View Controller Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 190.0
    }
    
    //MARK:- Actions
    @objc func moreBtnPressed(sender: UIButton) {
        
        for (_, cell) in tableView.visibleCells.enumerated() {
            if let optionView = cell.viewWithTag(-1) as? MenuView {
                if optionView.menuOpen {
                    optionView.close(withAnimation: true)
                }
            }
        }
        if let optionView = sender.superview?.superview?.viewWithTag(-1) as? MenuView {
            if optionView.menuOpen {
                optionView.close(withAnimation: true)
            } else {
                optionView.open(from: optionView.direction, withAnimation: true)
            }
        }
    }
    func showAlert(withTitle title: String = "Alert", description message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(okAction)
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertController.addAction(noAction)
        present(alertController, animated: true, completion: nil)
    }
    func setMenuLayout(_ layout: MenuLayout) {
        menuLayout = layout
    }
    func setMenuDirection(_ direction: Direction) {
        menuDirection = direction
    }
    
}

// MARK: - UITableViewDataSource

extension TableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MenuTableViewCell else {
            return UITableViewCell()
        }
        let firstItem = MenuItem(title: "Delete", icon: "delete") { (item) in
            self.showAlert(description: "Are you sure, you want to delete ?")
        }
       // firstItem.itemBorderColor = UIColor.white
        firstItem.itemBorderWidth = 2.0
       // firstItem.itemIconSize = CGSize(width: 70, height: 70)
      //  firstItem.titleColor = UIColor.gray
      //  firstItem.titleFont = UIFont.systemFont(ofSize: 11.0)
      //  firstItem.backgroundColor = UIColor.blue
        let secondItem = MenuItem(title: "Submit", icon: "save"){ (item) in
            self.showAlert(description: "Are you sure, you want to submit ?")
        }
        secondItem.itemBorderColor = UIColor.black
        secondItem.itemBorderWidth = 2.0
      //  item2.backgroundColor = UIColor.green
        let thirdItem = MenuItem(title: "Save", icon: "submit"){ (item) in
            self.showAlert(description: "Are you sure, you want to save ?")
        }
        thirdItem.itemBorderColor = UIColor.black
        thirdItem.itemBorderWidth = 2.0
      //  item3.backgroundColor = UIColor.yellow
       // WBMenuView.addOptionsView(tableViewCell: cell, [item1, item2, item3])
        let fourthItem = MenuItem(title: "Edit", icon: "edit"){ (item) in
            self.showAlert(description: "Are you sure, you want to edit ?")
        }
        fourthItem.itemBorderColor = UIColor.black
        fourthItem.itemBorderWidth = 2.0
        
        let menu = MenuView(mCell: cell, items: [firstItem, secondItem, thirdItem, fourthItem], indexPath: indexPath)
        menu.delegate = self
        menu.setupMenuLayout()
   //     menu.setMenuContentAlignment(.right)
        menu.setBgColor(UIColor(red: 90.0/255.0, green: 200.0/255.0, blue: 250.0/255.0, alpha: 1.0))
        menu.setMenuItemSpacingVertical(10.0)
        menu.setMenuItemSpacingHorizontal(15.0)
        menu.setMenuContentInset(10, left: 10, bottom: 10, right: -10)
        menu.tag = -1
        cell.moreButton.tag = indexPath.row
        cell.selectionStyle = .none
        cell.titleLabel.text = "Test Menu Cell"
        cell.moreButton.addTarget(self, action: #selector(moreBtnPressed(sender:)), for: .touchUpInside)
        return cell
    }
}

//MARK:- MenuViewDelegate

extension TableViewController: MenuViewDelegate {
    func menuView(_ view: MenuView, directionForRowAtIndexPath indexPath: IndexPath) -> Direction {
        return menuDirection ?? .right
    }
    func menuView(_ view: MenuView, menuLayoutForRowAtIndexPath indexPath: IndexPath) -> MenuLayout {
        return menuLayout ?? .horizontal
    }
    func menuView(_ view: MenuView, showMenuIconForRowAtIndexPath indexPath: IndexPath) -> Bool {
        return true
    }
    func menuView(_ menuview: MenuView, positionOfMenuIconForRowAtIndexPath indexPath: IndexPath) -> Direction {
        return .left
    }
 
}

