//
//  WBMenuItem.swift
//  WBSwipeToOptionCell
//
//  Created by MacBook on 4/28/18.
//  Copyright © 2018 Waqas Bhati. All rights reserved.
//

import UIKit

//MARK: Menu Item

/**
 ## Feature Support
 
 This class does some awesome things. It supports:
 
 - Support Menu Item ImageView icon, backgroundColor etc.
 - Support Title Label for Menu Item
 
 ## Examples
 
 Here is an example use case indented by four spaces because that indicates a
 code block:
 
 let firstItem = MenuItem(title: "Delete", icon: "delete") { (item) in
     // perform action on Button click
 }
 firstItem.itemBorderColor = UIColor.white // optional
 firstItem.itemBorderWidth = 2.0 // optional
 firstItem.itemIconSize = CGSize(width: 50, height: 60) // optional
 firstItem.titleColor = UIColor.gray // optional
 firstItem.titleFont = UIFont.systemFont(ofSize: 11.0) // optional
 firstItem.backgroundColor = UIColor.blue // optional
 
 ## Warnings
 
 There are some things you should be careful of:
 
 1. Menu Item Icon size is (50, 70) so superview should be bigger
 */

class MenuItem: UIView {
    
    //MARK: Instance Variables
    
    private var titleLabel = UILabel(frame: .zero)
    private var titleImageView = UIImageView(frame: .zero)
    private var actionButton = UIButton.init(type: .custom)
    private var stackView = UIStackView(frame: .zero)
    private var action:actionHandler?
    var itemIconSize: CGSize = CGSize(width: 50.0, height: 60.0)
    
    var titleColor: UIColor? {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    var itemBorderColor: UIColor? {
        didSet {
            actionButton.layer.borderColor = itemBorderColor?.cgColor
        }
    }
    var itemBorderWidth: CGFloat? {
        didSet {
            actionButton.layer.borderWidth = itemBorderWidth ?? 0.0
        }
    }
    var titleFont: UIFont? {
        didSet {
            titleLabel.font = titleFont
        }
    }
    var actionBtnIcon: String? {
        didSet {
            actionButton.setImage(UIImage(named: actionBtnIcon!), for: .normal)
        }
    }
    
    //MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    /**
     This method used to Initialize Menu Item
     
     - parameter title: title of the menu item
     - parameter icon: image name of the image view
     - parameter actionHandler: this will be block which will be called when we will click on menu Item
     */
    convenience init(title: String, icon: String, actionHandler: @escaping actionHandler) {
        self.init(frame: CGRect.zero)
        titleLabel.text = title
        titleImageView.image = UIImage(named: icon)
        action = actionHandler
        actionButton.addTarget(self, action: #selector(actionBtnPressed(sender:)), for: .touchUpInside)
        // setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(:coder) is not been implemented")
    }
    
    //MARK: Helper Methods
    
    /**
     This method used to setup Menu Item in the Menu View.
     
     */
    func setupMenuItemLayout() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 11.0)
        titleColor = UIColor.black
        titleLabel.textColor = UIColor.black
        
        titleImageView.heightAnchor.constraint(equalToConstant: itemIconSize.height).isActive = true
        titleImageView.widthAnchor.constraint(equalToConstant: itemIconSize.width).isActive = true
        titleImageView.contentMode = .scaleAspectFit
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        addSubview(stackView)
        
        stackView.layoutMargins = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        stackView.addArrangedSubview(titleImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(actionButton)
        actionButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        actionButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        actionButton.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        
    }
    
    //MARK: Action Methods
    
    @objc func actionBtnPressed(sender: UIButton) {
        guard let mAction = self.action else {
            return
        }
        mAction(self)
    }
    
}
