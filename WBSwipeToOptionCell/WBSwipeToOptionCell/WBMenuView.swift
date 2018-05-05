//
//  WBSwipeToOptionCell.swift
//  WBSwipeToOptionCell
//
//  Created by MacBook on 4/13/18.
//  Copyright © 2018 Waqas Bhati. All rights reserved.
//

import Foundation
import UIKit

typealias actionHandler = (MenuItem)->()

//MARK: Enums
enum ContentAlignment {
    case left, right, center, top, bottom
}
enum Gesture {
    case swipe, pan
}
enum Direction {
    case left, right, top, bottom
}
enum MenuLayout: Int {
    case horizontal = 0, vertical, square
}

//MARK: Menu View

/**
 ## Feature Support
 
 This class does some awesome things. It supports:
 
 - Support Horizontal Layout
 - Support Vertical Layout
 - Support Square Layout
 
 ## Examples
 
 Here is an example use case indented by four spaces because that indicates a
 code block:
 
 let menu = MenuView(tableViewCell: cell, items: [firstItem, secondItem, thirdItem], indexPath: indexPath)
 menu.delegate = self
 menu.setupMenuLayout()
 
 ## Warnings
 
 There are some things you should be careful of:
 
 1. For Vertical Layout, your cell height should be greater than 70
 2. For Horizontal Layout, your cell height should be greater than 70
 3. For Square Layout, your cell height should be greater than 140 as each item default size is 70, 70
 */

open class MenuView: UIView {
    
    //MARK: Instance Variables
    
    private var items: [MenuItem]?
    private var stackView = UIStackView(frame: .zero)
    private var stackViewTopRow = UIStackView(frame: .zero)
    private var stackViewBottomRow = UIStackView(frame: .zero)
    private var tableViewCell: UITableViewCell?
    private var changableConstraint: NSLayoutConstraint!
    private var direction: Direction = .right
    private var menuLayout: MenuLayout = .square
    private var contentAlignment: ContentAlignment = .center
    private var menuButton = UIButton.init(type: .custom)
    private var _menuOpen = false
    private var indexPath: IndexPath!
    private var centerXConstraint = NSLayoutConstraint()
    private var centerYConstraint = NSLayoutConstraint()
    private var leadingConstraint = NSLayoutConstraint()
    private var trailingConstraint = NSLayoutConstraint()
    private var topConstraint = NSLayoutConstraint()
    private var bottomConstraint = NSLayoutConstraint()

    weak var delegate: MenuViewDelegate?
    var menuOpen: Bool {
        return _menuOpen
    }
    var menuDirection: Direction {
        return direction
    }
    private enum Dimension {
        static var topSpacing: CGFloat = 5.0
        static var bottomSpacing: CGFloat = 5.0
        static var leftSpacing: CGFloat = 0.0
        static var rightSpacing: CGFloat = 0.0
        static var horizontalSpacing: CGFloat = 5.0
        static var verticalSpacing: CGFloat = 5.0
    }
    private enum MenuIcon {
        static let nameHorizontal = "more_H"
        static let nameVertical = "more"
    }
    private enum MenuButtonDimension {
        static let width: CGFloat = 20.0
        static let height: CGFloat = 30.0
    }
    
    /**
     This property used to set gesture(swipe, pan) in the Menu View
     
     */
    var swipeGesture: Gesture? {
        didSet {
            guard let tableViewCell = self.tableViewCell, let swipeGesture = swipeGesture else {
                return
            }
            switch swipeGesture {
            case .swipe:
                switch direction {
                case .left, .right:
                    tableViewCell.addGestureRecognizer(swipeLeftGestureRecognizer)
                    tableViewCell.addGestureRecognizer(swipeRightGestureRecognizer)
                case .top, .bottom:
                    fatalError("You can not add in case of Top and Bottom as It will conflict with TableView Scrolling")
                }
            case .pan:
                switch direction {
                case .left, .right:
                    tableViewCell.addGestureRecognizer(panGestureRecognizer)
                case .top, .bottom:
                    fatalError("You can not add in case of Top and Bottom as It will conflict with TableView Scrolling")
                }
            }
        }
    }
    
    lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        gesture.delegate = self
        return gesture
    }()
    lazy var swipeLeftGestureRecognizer: UISwipeGestureRecognizer = {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
        swipeLeft.direction = .left
        return swipeLeft
    }()
    lazy var swipeRightGestureRecognizer: UISwipeGestureRecognizer = {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
        swipeRight.direction = .right
        return swipeRight
    }()
    
    //MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    /**
     This method used to initialize Menu View
     
     - parameter tableViewCell: cell on which we want to show Menu View
     - parameter items: array of menu Items that will be shown in Menu View
     - parameter gesture: we can provide two type of gesture to the cell default will be swipe //optional
     - parameter indexPath: indexPath of the tableViewCell
     */
    convenience init(tableViewCell: UITableViewCell, items: [MenuItem], gesture: Gesture? = .swipe, indexPath: IndexPath) {
        self.init(frame: CGRect.zero)
        self.tableViewCell = tableViewCell
        self.items = items
        self.indexPath = indexPath
        self.menuButton.addTarget(self, action: #selector(menuBtnPressed(sender:)), for: .touchUpInside)
        defer {
            self.swipeGesture = gesture
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Init(:coder) is not been implemented")
    }
    
    //MARK: Helper Methods
    
    /**
     This method used to open Menu View.
     
     - parameter direction: The direction from which you want to open
     - parameter animated: Animation that will be used to animate view opening
     */
    func open(from direction: Direction,withAnimation animated: Bool) {
        guard let changableConstraint = self.changableConstraint  else {
            return
        }
        _menuOpen = true
        var value = CGFloat(0.0)
        switch direction {
        case .left,.right:
            value = -frame.size.width
        case .top,.bottom:
            value = -frame.size.height
        }
        changableConstraint.constant = value
        if animated {
            UIView.animate(withDuration: 1.0) {
                self.tableViewCell?.layoutIfNeeded()
            }
        } else {
            self.tableViewCell?.layoutIfNeeded()
        }
    }
    /**
     This method used to close Menu View
     */
    func close(withAnimation animated: Bool) {
        guard let changableConstraint = self.changableConstraint  else {
            return
        }
        _menuOpen = false
        changableConstraint.constant = 0.0
        if animated {
            UIView.animate(withDuration: 1.0) {
                self.tableViewCell?.layoutIfNeeded()
            }
        } else {
            self.tableViewCell?.layoutIfNeeded()
        }
    }
    
    /**
     This method is used for Menu Layout on the base of
     
     */
    private func setupContentMenuLayout(menuLayout: MenuLayout) {
        switch menuLayout {
        case .horizontal, .vertical:
            stackView.distribution = .fill
            stackView.axis = UILayoutConstraintAxis(rawValue: menuLayout.rawValue) ?? .horizontal
            addSubview(stackView)
        case .square:
            stackView.distribution = .fillEqually
            stackView.axis = .vertical
            addSubview(stackView)
            guard let items = self.items else {
                return
            }
            if items.count > 1 {
                stackView.addArrangedSubview(stackViewTopRow)
                stackView.addArrangedSubview(stackViewBottomRow)
                setMenuItemsHorizontalSpacing(Dimension.horizontalSpacing)
            }
        }
        
        centerXConstraint = stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        centerYConstraint = stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        leadingConstraint = stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 0)
        trailingConstraint = stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: 0)
        topConstraint = stackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 0)
        bottomConstraint = stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: 0)

        centerXConstraint.isActive = true
        centerYConstraint.isActive = true
        trailingConstraint.isActive = true
        leadingConstraint.isActive = true
        topConstraint.isActive = true
        bottomConstraint.isActive = true
    }
    
    /**
     This method used to provide layout direction
     
     - parameter name: direction (left, right, top, bottom) layout will be based on the direction
     */
    private func setupLayoutDirection(_ direction: Direction) {
        guard let tableViewCell = self.tableViewCell else {
            return
        }
        setupMenuItems(tableViewCell, with: menuLayout)
        showMenuIn(tableViewCell, from: direction)
    }
    /**
     This method used to position menu three dot Icon
     
     */
    private func setupMenuIconPosition() {
        if let show = delegate?.menuView(self, showMenuIconForRowAtIndexPath: indexPath) {
            if show == true {
                if let position = delegate?.menuView(self, positionOfMenuIconForRowAtIndexPath: indexPath) {
                    switch position {
                    case .left:
                        showLeftMenuIcon()
                    case .right:
                        showRightMenuIcon()
                    case .top:
                        showTopMenuIcon()
                    case .bottom:
                        showBottomMenuIcon()
                    }
                }
            }
        }
    }
    /**
     This method used to set Menu main layout, we will call this function once we want the Menu View.
     
     */
    func setupMenuLayout() {
        
        backgroundColor = UIColor.brown
        translatesAutoresizingMaskIntoConstraints = false
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        
        if let menuLayout = delegate?.menuView(self, menuLayoutForRowAtIndexPath: indexPath) {
            self.menuLayout = menuLayout
        }
        setupContentMenuLayout(menuLayout: self.menuLayout)
        
        setMenuContentSpacing(Dimension.topSpacing, left: Dimension.leftSpacing, bottom: Dimension.bottomSpacing, right: Dimension.rightSpacing)
        setMenuItemsHorizontalSpacing(Dimension.horizontalSpacing)
        
        if let direction = delegate?.menuView(self, directionForRowAtIndexPath: indexPath) {
            self.direction = direction
        }
        setupLayoutDirection(direction)
        setupMenuIconPosition()
    }
    /**
     This method used to show menu Icon in left position
     
     */
    private func showRightMenuIcon() {
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        setMenuIcon(name: MenuIcon.nameVertical)
      //  menuBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        addSubview(menuButton)
        menuButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.0).isActive = true
        menuButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0.0).isActive = true
        menuButton.heightAnchor.constraint(equalToConstant: MenuButtonDimension.height).isActive = true
        menuButton.widthAnchor.constraint(equalToConstant: MenuButtonDimension.width).isActive = true
    }
    /**
     This method used to show menu Icon in right position

     */
    private func showLeftMenuIcon() {
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        setMenuIcon(name: MenuIcon.nameVertical)
     //   menuBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        addSubview(menuButton)
        menuButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0).isActive = true
        menuButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0.0).isActive = true
        menuButton.heightAnchor.constraint(equalToConstant: MenuButtonDimension.height).isActive = true
        menuButton.widthAnchor.constraint(equalToConstant: MenuButtonDimension.width).isActive = true
    }
    /**
     This method used to show menu Icon in top position
     
     */
    private func showTopMenuIcon() {
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        setMenuIcon(name: MenuIcon.nameHorizontal)
        menuButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        addSubview(menuButton)
        menuButton.topAnchor.constraint(equalTo: topAnchor, constant: 10.0).isActive = true
        menuButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0.0).isActive = true
        menuButton.heightAnchor.constraint(equalToConstant: MenuButtonDimension.width).isActive = true
        menuButton.widthAnchor.constraint(equalToConstant: MenuButtonDimension.height).isActive = true
    }
    /**
     This method used to show menu Icon in bottom position
     
     */
    private func showBottomMenuIcon() {
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        setMenuIcon(name: MenuIcon.nameHorizontal)
        menuButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        addSubview(menuButton)
        menuButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0).isActive = true
        menuButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0.0).isActive = true
        menuButton.heightAnchor.constraint(equalToConstant: MenuButtonDimension.width).isActive = true
        menuButton.widthAnchor.constraint(equalToConstant: MenuButtonDimension.height).isActive = true
    }
    /**
     This method used to layout Menu items in the Menu View
     
     - parameter tableViewCell: cell on which we want Menu View to be displayed
     - parameter menuLayout: MenuLayout (horizontal, vertical, square) on this basis we will display Menu Items in Layout
     */
    private func setupMenuItems(_ tableViewCell: UITableViewCell,with menuLayout: MenuLayout) {
        guard let items = items else {
            return
        }
        switch menuLayout {
        case .horizontal, .vertical:
            for item in items {
              item.setupMenuItemLayout()
              stackView.addArrangedSubview(item)
            }
        case .square:
            if items.count > 1 {
                for (index, item) in items.enumerated() {
                    if index % 2 == 0 {
                        item.setupMenuItemLayout()
                        stackViewTopRow.addArrangedSubview(item)
                    } else {
                        item.setupMenuItemLayout()
                        stackViewBottomRow.addArrangedSubview(item)
                    }
                }
            } else {
                for item in items {
                    item.setupMenuItemLayout()
                    stackView.addArrangedSubview(item)
                }
            }
        }
        tableViewCell.addSubview(self)
    }
    /**
     This method used to show Menu from left, right, top or bottom direction
     
     - parameter tableViewCell: cell on which we want Menu View to be displayed
     - parameter menuLayout: MenuLayout (horizontal, vertical, square) on this basis we will display Menu Items in Layout
     */
    private func showMenuIn(_ tableViewCell: UITableViewCell,from direction: Direction) {
        switch direction {
        case .left:
            changableConstraint = tableViewCell.leadingAnchor.constraint(equalTo: trailingAnchor)
            changableConstraint?.isActive = true
            widthAnchor.constraint(equalTo: tableViewCell.widthAnchor, constant: 0.0).isActive = true
            topAnchor.constraint(equalTo: tableViewCell.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: tableViewCell.bottomAnchor).isActive = true
        case .right:
            changableConstraint = leadingAnchor.constraint(equalTo: tableViewCell.trailingAnchor)
            changableConstraint?.isActive = true
            widthAnchor.constraint(equalTo: tableViewCell.widthAnchor, constant: 0.0).isActive = true
            topAnchor.constraint(equalTo: tableViewCell.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: tableViewCell.bottomAnchor).isActive = true
        case .top:
            changableConstraint = tableViewCell.topAnchor.constraint(equalTo: bottomAnchor)
            changableConstraint?.isActive = true
            heightAnchor.constraint(equalTo: tableViewCell.heightAnchor, constant: 0.0).isActive = true
            leadingAnchor.constraint(equalTo: tableViewCell.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: tableViewCell.trailingAnchor).isActive = true
        case .bottom:
            changableConstraint = topAnchor.constraint(equalTo: tableViewCell.bottomAnchor)
            changableConstraint?.isActive = true
            heightAnchor.constraint(equalTo: tableViewCell.heightAnchor, constant: 0.0).isActive = true
            leadingAnchor.constraint(equalTo: tableViewCell.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: tableViewCell.trailingAnchor).isActive = true
        }
    }
    
    //MARK: Action Methods
    
    @objc func menuBtnPressed(sender: UIButton) {
        if _menuOpen {
            close(withAnimation: true)
        } else {
            open(from: direction, withAnimation: true)
        }
    }
    
    //MARK: Gesture Handling Methods
    
    /**
     This method used to handle swipe gesture
     
     - parameter gesture: swipe gesture from which we will get swipe direction
     */
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer) {
        switch direction {
        case .left:
            switch gesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                open(from: .left, withAnimation: true)
            case UISwipeGestureRecognizerDirection.left:
                close(withAnimation: true)
            default: break
            }
        case .right:
            switch gesture.direction {
            case UISwipeGestureRecognizerDirection.left:
                open(from: .right, withAnimation: true)
            case UISwipeGestureRecognizerDirection.right:
                close(withAnimation: true)
            default: break
            }
        default:
            print("Default")
        }
    }
    /**
     This method used to handle pan gesture
     
     - parameter gesture: pan gesture from which we will get velocity, angle etc.
     */
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        guard let tableViewCell = self.tableViewCell, let leadingConstraint = self.changableConstraint else {
            return
        }
        let translation = gesture.translation(in: tableViewCell)
        let newX = leadingConstraint.constant + translation.x
        if newX >= -frame.size.width && newX <= 0.0 {
            leadingConstraint.constant = newX
            gesture.setTranslation(CGPoint.zero, in: tableViewCell)
        }
    }
}

//MARK: Alignment and Spacing Methods

extension MenuView {
    /**
     This method is used for content spacing like leading, trailing, top and bottom
     
     */
    private func setMenuContentSpacing(_ top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        
        leadingConstraint.constant = left
        trailingConstraint.constant = right
        topConstraint.constant = top
        bottomConstraint.constant = bottom
    }
    /**
     This method is used to set Content Alignment.
     
     - parameter alignment: This can be used to alignment content to left, right, center
     */

    func setMenuContentAlignment(_ alignment: ContentAlignment) {
        self.contentAlignment = alignment
        switch alignment {
        case .left:
            centerXConstraint.isActive = false
            leadingConstraint.isActive = true
        case .center:
            stackView.alignment = .center
        case .right:
            centerXConstraint.isActive = false
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
        case .bottom:
            centerYConstraint.isActive = false
            bottomConstraint.isActive = true
        case .top:
            centerYConstraint.isActive = false
            bottomConstraint.isActive = false
            topConstraint.isActive = true
        }
    }
    /**
     This method used to set Menu Button Image
     
     - parameter name: This will be the name of image
     */

    func setMenuIcon(name: String) {
        menuButton.setImage(UIImage(named: name), for: .normal)
    }
    /**
     This method used to set Menu background color
     
     - parameter name: this is the color
     */
    func setBackgroundColor(_ color: UIColor) {
        backgroundColor = color
    }
    /**
     This method used to set horizontal spacing between two Items
     
     - parameter spacing: constant value of spacing
     */
    private func setMenuItemsHorizontalSpacing(_ spacing: CGFloat) {
        switch menuLayout {
        case .horizontal:
            stackView.spacing = spacing
        case .square:
            stackViewTopRow.spacing = spacing
            stackViewBottomRow.spacing = spacing
        default: return
        }
    }
    /**
     This method used to set horizontal spacing between two Items

     - parameter name: This will be the name of image
     */
    private func setMenuItemsVerticalSpacing(_ spacing: CGFloat) {
        switch menuLayout {
        case .vertical, .square:
            stackView.spacing = spacing
        default: return
        }
    }
    /**
     This method used to set Menu Content top, bottom, left and right spacing from cell
     
     - parameter top: This is used to add top spacing from superview
     - parameter left: This is used to add left spacing from superview
     - parameter bottom: This is used to add bottom spacing from superview
     - parameter right: This is used to add right spacing from superview
     */
    func setMenuContentInset(_ top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        Dimension.topSpacing = top
        Dimension.bottomSpacing = bottom
        Dimension.leftSpacing =  left
        Dimension.rightSpacing = right
        setMenuContentSpacing(top, left: left, bottom: bottom, right: right)
    }
    /**
     This method used to set Vertical spacing between Menu Items
     
     - parameter vertical: space constant between 2 menu Items
     */
    func setMenuItemSpacingVertical(_ vertical: CGFloat) {
       Dimension.verticalSpacing = vertical
        setMenuItemsVerticalSpacing(Dimension.verticalSpacing)
    }
    /**
     This method used to set Horizontal spacing between Menu Items
     
     - parameter horizontal: space constant between 2 menu Items
     */
    func setMenuItemSpacingHorizontal(_ horizontal: CGFloat) {
        Dimension.horizontalSpacing = horizontal
        setMenuItemsHorizontalSpacing(Dimension.horizontalSpacing)
    }
}

//MARK: Gesture Recgonizer Delegate

extension MenuView: UIGestureRecognizerDelegate {
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer || gestureRecognizer is UISwipeGestureRecognizer {
            return true
        }
        return false
    }
    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let tableViewCell = tableViewCell else {
            return false
        }
        if let pan = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = pan.velocity(in: tableViewCell)
            let radian = atan(velocity.y/velocity.x)
            let degree = Double(radian * 180) / Double.pi
            let thresholdAngle = 20.0
            if (fabs(degree) > thresholdAngle) {
                return false
            }
        }
        return true
    }
}

