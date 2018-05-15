//
//  CollectionViewController.swift
//  WBSwipeToOptionCell
//
//  Created by MacBook on 5/12/18.
//  Copyright © 2018 Waqas Sultan. All rights reserved.
//

import UIKit
import WBSwipeableCell

class CollectionViewController: UIViewController {

    //MARK:- Instance Variables

    @IBOutlet weak var collectionView: UICollectionView!
    private var items: [MenuView]?
    private var menuLayout: MenuLayout?
    private var menuDirection: Direction?
    
    //MARK:- View Controller Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK:- Actions
    @objc func moreBtnPressed(sender: UIButton) {
        
        for (_, cell) in collectionView.visibleCells.enumerated() {
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

// MARK: - UICollectionViewDelegateFlowLayout

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if menuLayout == .horizontal {
            return CGSize(width: collectionView.frame.size.width, height: 280.0)
        }
        return CGSize(width: collectionView.frame.size.width/2.0, height: 280.0)
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID",
                                                            for: indexPath) as? MenuCollectionViewCell else {
           return MenuCollectionViewCell()
        }

        let firstItem = MenuItem(title: "Delete", icon: "delete") { (item) in
            self.showAlert(description: "Are you sure, you want to delete ?")
        }
        // firstItem.itemBorderColor = UIColor.white
        firstItem.itemBorderWidth = 2.0
        firstItem.itemIconSize = CGSize(width: 50, height: 30)
        //  firstItem.titleColor = UIColor.gray
        //  firstItem.titleFont = UIFont.systemFont(ofSize: 11.0)
        //  firstItem.backgroundColor = UIColor.blue
        let secondItem = MenuItem(title: "Submit", icon: "save"){ (item) in
            self.showAlert(description: "Are you sure, you want to submit ?")
        }
        secondItem.itemBorderColor = UIColor.black
        secondItem.itemBorderWidth = 2.0
        secondItem.itemIconSize = CGSize(width: 50, height: 30)
        //  item2.backgroundColor = UIColor.green
        let thirdItem = MenuItem(title: "Save", icon: "submit"){ (item) in
            self.showAlert(description: "Are you sure, you want to save ?")
        }
        thirdItem.itemBorderColor = UIColor.black
        thirdItem.itemBorderWidth = 2.0
        thirdItem.itemIconSize = CGSize(width: 50, height: 30)
        //  item3.backgroundColor = UIColor.yellow
        // WBMenuView.addOptionsView(tableViewCell: cell, [item1, item2, item3])
        let fourthItem = MenuItem(title: "Edit", icon: "edit"){ (item) in
            self.showAlert(description: "Are you sure, you want to edit ?")
        }
        fourthItem.itemBorderColor = UIColor.black
        fourthItem.itemBorderWidth = 2.0
        fourthItem.itemIconSize = CGSize(width: 50, height: 30)

        let menu = MenuView(mCell: cell, items: [firstItem, secondItem, thirdItem, fourthItem], indexPath: indexPath)
        menu.delegate = self
        menu.setupMenuLayout()
        menu.setMenuContentAlignment(.center)
        menu.setBgColor(UIColor(red: 90.0/255.0, green: 200.0/255.0, blue: 250.0/255.0, alpha: 1.0))
        menu.setMenuItemSpacingVertical(5.0)
        menu.setMenuItemSpacingHorizontal(15.0)
        menu.setMenuContentInset(10, left: 10, bottom: 10, right: -10)
        menu.tag = -1
        cell.moreButton.tag = indexPath.row
        cell.titleLabel.text = "Test Menu Cell"
        cell.moreButton.addTarget(self, action: #selector(moreBtnPressed(sender:)), for: .touchUpInside)
        return cell
    }
    
}

//MARK:- MenuViewDelegate

extension CollectionViewController: MenuViewDelegate {
    func menuView(_ view: MenuView, directionForRowAtIndexPath indexPath: IndexPath) -> Direction {
        return menuDirection ?? .right
    }
    func menuView(_ view: MenuView, menuLayoutForRowAtIndexPath indexPath: IndexPath) -> MenuLayout {
        return menuLayout ?? .square
    }
    func menuView(_ view: MenuView, showMenuIconForRowAtIndexPath indexPath: IndexPath) -> Bool {
        return true
    }
    func menuView(_ menuview: MenuView, positionOfMenuIconForRowAtIndexPath indexPath: IndexPath) -> Direction {
        return .left
    }
    
}
