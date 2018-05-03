//
//  WBSwipeToOptionCell.swift
//  WBSwipeToOptionCell
//
//  Created by MacBook on 4/13/18.
//  Copyright © 2018 Waqas Sultan. All rights reserved.
//

import Foundation
import UIKit

typealias actionHandler = (MenuItem)->()

//MARK: Enums
enum ContentAlignment {
    case left, right, center
}
enum Gesture {
    case swipe
    case pan
}
enum Direction {
    case left, right, top, bottom
}
enum MenuLayout: Int {
    case horizontal = 0, vertical, square
}

//MARK: Class

class MenuView: UIView {
    
    //MARK: Instance Variables
    
    private var items: [MenuItem]?
    private var stackView = UIStackView(frame: .zero)
    private var stackViewTop = UIStackView(frame: .zero)
    private var stackViewBottom = UIStackView(frame: .zero)
    private var tableViewCell: UITableViewCell?
    private var changableConstraint: NSLayoutConstraint!
    private var direction: Direction = .right
    private var menuLayout: MenuLayout = .square
    private var menuBtn = UIButton.init(type: .custom)
    private var _isMenuOpen = false
    private var indexPath: IndexPath!
    weak var delegate: MenuViewDelegate?
    var isMenuOpen: Bool {
        return _isMenuOpen
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
    private enum MenuBtnDimension {
        static let width: CGFloat = 20.0
        static let height: CGFloat = 30.0
    }
    
    public var swipeGesture: Gesture! {
        didSet {
            guard let tableViewCell = self.tableViewCell else {
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
                tableViewCell.addGestureRecognizer(panGestureRecognizer)
            case .none:
                fatalError("You need to provide Gesture")
            case .some(_):
                fatalError("You need to provide Gesture")
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
    convenience init(tableViewCell: UITableViewCell, items: [MenuItem], gesture: Gesture? = .swipe, indexPath: IndexPath) {
        self.init(frame: CGRect.zero)
        self.tableViewCell = tableViewCell
        self.items = items
        self.indexPath = indexPath
        self.menuBtn.addTarget(self, action: #selector(menuBtnPressed(sender:)), for: .touchUpInside)
        defer {
            self.swipeGesture = gesture
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(:coder) is not been implemented")
    }
    
    //MARK: Helper Methods
    
    func open() {
        guard let changableConstraint = self.changableConstraint  else {
            return
        }
        _isMenuOpen = true
        var value = CGFloat(0.0)
        switch direction {
        case .left,.right:
            value = -frame.size.width
        case .top,.bottom:
            value = -frame.size.height
        }
        changableConstraint.constant = value
        UIView.animate(withDuration: 1.0) {
            self.tableViewCell?.layoutIfNeeded()
        }
    }
    func close() {
        guard let changableConstraint = self.changableConstraint  else {
            return
        }
        _isMenuOpen = false
        changableConstraint.constant = 0.0
        UIView.animate(withDuration: 1.0) {
            self.tableViewCell?.layoutIfNeeded()
        }
    }
    
    private func setupContentSpacing() {
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: Dimension.leftSpacing).isActive = true
        stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: Dimension.rightSpacing).isActive = true
        stackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: Dimension.topSpacing).isActive = true
        stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: Dimension.bottomSpacing).isActive = true
    }
    private func setupContentMenuLayout() {
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
                stackView.addArrangedSubview(stackViewTop)
                stackView.addArrangedSubview(stackViewBottom)
                setupContentHorizontalSpacing()
            }
        }
    }
    private func setupContentHorizontalSpacing() {
        stackViewTop.spacing = Dimension.horizontalSpacing
        stackViewBottom.spacing = Dimension.horizontalSpacing
    }
    private func setupContentVerticalSpacing() {
        stackView.spacing = Dimension.verticalSpacing
    }
    private func setupLayoutDirection() {
        guard let tableViewCell = self.tableViewCell else {
            return
        }
        setupMenuItems(tableViewCell)

        switch direction {
        case .left:
            showLeftMenu(tableViewCell)
        case .right:
            showRightMenu(tableViewCell)
        case .top:
            showTopMenu(tableViewCell)
        case .bottom:
            showBottomMenu(tableViewCell)
        }
    }
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
    func setupUI() {
        
        backgroundColor = UIColor.brown
        translatesAutoresizingMaskIntoConstraints = false
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        
        if let menuLayout = delegate?.menuView(self, menuLayoutForRowAtIndexPath: indexPath) {
            self.menuLayout = menuLayout
        }
        setupContentMenuLayout()
        
        setupContentSpacing()
        setupContentHorizontalSpacing()
        
        if let direction = delegate?.menuView(self, directionForRowAtIndexPath: indexPath) {
            self.direction = direction
        }
        setupLayoutDirection()
        setupMenuIconPosition()
    }
    private func showLeftMenuIcon() {
        menuBtn.translatesAutoresizingMaskIntoConstraints = false
        setMenuIcon(name: MenuIcon.nameVertical)
        menuBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        addSubview(menuBtn)
        menuBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.0).isActive = true
        menuBtn.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0.0).isActive = true
        menuBtn.heightAnchor.constraint(equalToConstant: MenuBtnDimension.height).isActive = true
        menuBtn.widthAnchor.constraint(equalToConstant: MenuBtnDimension.width).isActive = true
    }
    private func showRightMenuIcon() {
        menuBtn.translatesAutoresizingMaskIntoConstraints = false
        setMenuIcon(name: MenuIcon.nameVertical)
        menuBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        addSubview(menuBtn)
        menuBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0).isActive = true
        menuBtn.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0.0).isActive = true
        menuBtn.heightAnchor.constraint(equalToConstant: MenuBtnDimension.height).isActive = true
        menuBtn.widthAnchor.constraint(equalToConstant: MenuBtnDimension.width).isActive = true
    }
    private func showTopMenuIcon() {
        menuBtn.translatesAutoresizingMaskIntoConstraints = false
        setMenuIcon(name: MenuIcon.nameHorizontal)
        menuBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        addSubview(menuBtn)
        menuBtn.topAnchor.constraint(equalTo: topAnchor, constant: 10.0).isActive = true
        menuBtn.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0.0).isActive = true
        menuBtn.heightAnchor.constraint(equalToConstant: MenuBtnDimension.width).isActive = true
        menuBtn.widthAnchor.constraint(equalToConstant: MenuBtnDimension.height).isActive = true
    }
    private func showBottomMenuIcon() {
        menuBtn.translatesAutoresizingMaskIntoConstraints = false
        setMenuIcon(name: MenuIcon.nameHorizontal)
        menuBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        addSubview(menuBtn)
        menuBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0).isActive = true
        menuBtn.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0.0).isActive = true
        menuBtn.heightAnchor.constraint(equalToConstant: MenuBtnDimension.width).isActive = true
        menuBtn.widthAnchor.constraint(equalToConstant: MenuBtnDimension.height).isActive = true
    }
    private func setupMenuItems(_ tableViewCell: UITableViewCell) {
        guard let items = items else {
            return
        }
        switch menuLayout {
        case .horizontal, .vertical:
            for item in items {
              item.setupUI()
              stackView.addArrangedSubview(item)
            }
        case .square:
            if items.count > 1 {
                for (index, item) in items.enumerated() {
                    if index % 2 == 0 {
                        item.setupUI()
                        stackViewTop.addArrangedSubview(item)
                    } else {
                        item.setupUI()
                        stackViewBottom.addArrangedSubview(item)
                    }
                }
            } else {
                for item in items {
                    item.setupUI()
                    stackView.addArrangedSubview(item)
                }
            }
        }
        tableViewCell.addSubview(self)
    }
    private func showLeftMenu(_ tableViewCell: UITableViewCell) {
        changableConstraint = tableViewCell.leadingAnchor.constraint(equalTo: trailingAnchor)
        changableConstraint?.isActive = true
        widthAnchor.constraint(equalTo: tableViewCell.widthAnchor, constant: 0.0).isActive = true
        topAnchor.constraint(equalTo: tableViewCell.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: tableViewCell.bottomAnchor).isActive = true
    }
    private func showRightMenu(_ tableViewCell: UITableViewCell) {
        changableConstraint = leadingAnchor.constraint(equalTo: tableViewCell.trailingAnchor)
        changableConstraint?.isActive = true
        widthAnchor.constraint(equalTo: tableViewCell.widthAnchor, constant: 0.0).isActive = true
        topAnchor.constraint(equalTo: tableViewCell.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: tableViewCell.bottomAnchor).isActive = true
    }
    private func showTopMenu(_ tableViewCell: UITableViewCell) {
        changableConstraint = tableViewCell.topAnchor.constraint(equalTo: bottomAnchor)
        changableConstraint?.isActive = true
        heightAnchor.constraint(equalTo: tableViewCell.heightAnchor, constant: 0.0).isActive = true
        leadingAnchor.constraint(equalTo: tableViewCell.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: tableViewCell.trailingAnchor).isActive = true
    }
    private func showBottomMenu(_ tableViewCell: UITableViewCell) {
        changableConstraint = topAnchor.constraint(equalTo: tableViewCell.bottomAnchor)
        changableConstraint?.isActive = true
        heightAnchor.constraint(equalTo: tableViewCell.heightAnchor, constant: 0.0).isActive = true
        leadingAnchor.constraint(equalTo: tableViewCell.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: tableViewCell.trailingAnchor).isActive = true
    }
    
    //MARK: Action Methods
    
    @objc func menuBtnPressed(sender: UIButton) {
        if _isMenuOpen {
            close()
        } else {
            open()
        }
    }
    
    //MARK: Gesture Handling Methods
    
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer) {
        switch direction {
        case .left:
            switch gesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                open()
            case UISwipeGestureRecognizerDirection.left:
                close()
            default: break
            }
        case .right:
            switch gesture.direction {
            case UISwipeGestureRecognizerDirection.left:
                open()
            case UISwipeGestureRecognizerDirection.right:
                close()
            default: break
            }
        default:
            print("Default")
        }
    }
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
    func setMenuContentAlignment(_ alignment: ContentAlignment) {
        switch alignment {
        case .left:
            stackView.alignment = .leading
        case .center:
            stackView.alignment = .center
        case .right:
            stackView.alignment = .trailing
        }
    }
    func setMenuIcon(name: String) {
        menuBtn.setImage(UIImage(named: name), for: .normal)
    }
    func setBackgroundColor(_ color: UIColor) {
        backgroundColor = color
    }
    func setMenuContentInset(_ top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        Dimension.topSpacing = top
        Dimension.bottomSpacing = bottom
        Dimension.leftSpacing =  left
        Dimension.rightSpacing = right
        setupContentSpacing()
    }
    func setMenuItemSpacingVertical(_ vertical: CGFloat) {
       Dimension.verticalSpacing = vertical
       setupContentVerticalSpacing()
    }
    func setMenuItemSpacingHorizontal(_ horizontal: CGFloat) {
        Dimension.horizontalSpacing = horizontal
        setupContentHorizontalSpacing()
    }
}

//MARK: Gesture Recgonizer Delegate

extension MenuView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer || gestureRecognizer is UISwipeGestureRecognizer {
            return true
        }
        return false
    }
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
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

