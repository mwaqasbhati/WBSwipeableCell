//
//  WBSwipeToOptionCell.swift
//  WBSwipeToOptionCell
//
//  Created by MacBook on 4/13/18.
//  Copyright © 2018 Waqas Sultan. All rights reserved.
//

import Foundation
import UIKit

typealias actionHandler = (WBMenuItem)->()

//MARK: Enums
enum ConentAlignment {
    case left, right, center
}
enum WBGesture {
    case Swipe
    case Pan
}
enum Direction {
    case Left, Right, Top, Bottom
}
enum MenuLayout: Int {
    case Horizontal = 0, Vertical, Square
}

protocol WBMenuViewDelegate: class {
    func menuView(_ view: WBMenuView, directionForRowAtIndexPath indexPath: IndexPath) -> Direction
    func menuView(_ view: WBMenuView, menuLayoutForRowAtIndexPath indexPath: IndexPath) -> MenuLayout
    func menuView(_ view: WBMenuView, showMenuIconForRowAtIndexPath indexPath: IndexPath) -> Bool
    func menuView(_ view: WBMenuView, positionOfMenuIconForRowAtIndexPath indexPath: IndexPath) -> Direction
}

extension WBMenuViewDelegate {
    func menuView(_ view: WBMenuView, directionForRowAtIndexPath indexPath: IndexPath) -> Direction {
        return .Bottom
    }
    func menuView(_ view: WBMenuView, menuLayoutForRowAtIndexPath indexPath: IndexPath) -> MenuLayout {
        return .Horizontal
    }
    func menuView(_ view: WBMenuView, showMenuIconForRowAtIndexPath indexPath: IndexPath) -> Bool {
        return true
    }
    func menuView(_ view: WBMenuView, positionOfMenuIconForRowAtIndexPath indexPath: IndexPath) -> Direction {
        return .Top
    }
}

class WBMenuView: UIView {
    
    //MARK: Instance Variables
    private var items: [WBMenuItem]?
    private var stackView = UIStackView(frame: CGRect.zero)
    private var stackViewTop = UIStackView(frame: CGRect.zero)
    private var stackViewBottom = UIStackView(frame: CGRect.zero)
    private var tableViewCell: UITableViewCell?
    private var changableConstraint: NSLayoutConstraint!
    private var direction: Direction = .Right
    private var menuLayout: MenuLayout = .Square
    private var menuBtn = UIButton.init(type: UIButtonType.custom)
    private var _isMenuOpen = false
    private var indexPath: IndexPath!
    weak var delegate: WBMenuViewDelegate?
    var isMenuOpen: Bool {
        return _isMenuOpen
    }

    private var topSpacing: CGFloat = 5.0
    private var bottomSpacing: CGFloat = 5.0
    private var leftSpacing: CGFloat = 0.0
    private var rightSpacing: CGFloat = 0.0
    private var horizontalSpacing: CGFloat = 5.0
    private var verticalSpacing: CGFloat = 5.0

    public var swipeGesture: WBGesture! {
        didSet {
            guard let tableViewCell = self.tableViewCell else {
                return
            }
            switch swipeGesture {
            case .Swipe:
                switch direction {
                case .Left, .Right:
                    tableViewCell.addGestureRecognizer(swipeLeftGestureRecognizer)
                    tableViewCell.addGestureRecognizer(swipeRightGestureRecognizer)
                case .Top, .Bottom:
                    fatalError("You can not add in case of Top and Bottom as It will conflict with TableView Scrolling")
                }
            case .Pan:
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
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture(gesture:)))
        swipeLeft.direction = .left
        return swipeLeft
    }()
    lazy var swipeRightGestureRecognizer: UISwipeGestureRecognizer = {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture(gesture:)))
        swipeRight.direction = .right
        return swipeRight
    }()
    
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
    
    //MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init(tableViewCell: UITableViewCell, items: [WBMenuItem], gesture: WBGesture? = .Swipe, indexPath: IndexPath) {
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
    
    //MARK: Gesture Handling Methods
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) {
        
        switch direction {
        case .Left:
            switch gesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                open()
            case UISwipeGestureRecognizerDirection.left:
                close()
            default: break
                
            }
        case .Right:
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
    
    
    
    //MARK: Helper Methods
    func open() {
        guard let changableConstraint = self.changableConstraint  else {
            return
        }
        _isMenuOpen = true
        var value = CGFloat(0.0)
        switch direction {
        case .Left,.Right:
            value = -frame.size.width
        case .Top,.Bottom:
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
        stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: leftSpacing).isActive = true
        stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: rightSpacing).isActive = true
        stackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: topSpacing).isActive = true
        stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: bottomSpacing).isActive = true
    }
    private func setupContentMenuLayout() {
        switch menuLayout {
        case .Horizontal, .Vertical:
            stackView.distribution = .fill
            stackView.axis = UILayoutConstraintAxis(rawValue: menuLayout.rawValue) ?? .horizontal
            addSubview(stackView)
        case .Square:
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
        stackViewTop.spacing = horizontalSpacing
        stackViewBottom.spacing = horizontalSpacing
    }
    private func setupContentVerticalSpacing() {
        stackView.spacing = verticalSpacing
    }
    private func setupLayoutDirection() {
        guard let tableViewCell = self.tableViewCell else {
            return
        }
        setupMenuItems(tableViewCell)

        switch direction {
        case .Left:
            showLeftMenu(tableViewCell)
        case .Right:
            showRightMenu(tableViewCell)
        case .Top:
            showTopMenu(tableViewCell)
        case .Bottom:
            showBottomMenu(tableViewCell)
        }
    }
    private func setupMenuIconPosition() {
        if let show = delegate?.menuView(self, showMenuIconForRowAtIndexPath: indexPath) {
            if show == true {
                if let position = delegate?.menuView(self, positionOfMenuIconForRowAtIndexPath: indexPath) {
                    switch position {
                    case .Left:
                        showLeftMenuIcon()
                    case .Right:
                        showRightMenuIcon()
                    case .Top:
                        showTopMenuIcon()
                    case .Bottom:
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
        setMenuIcon(name: "more")
        menuBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        addSubview(menuBtn)
        menuBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.0).isActive = true
        menuBtn.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0.0).isActive = true
        menuBtn.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        menuBtn.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
    }
    private func showRightMenuIcon() {
        menuBtn.translatesAutoresizingMaskIntoConstraints = false
        setMenuIcon(name: "more")
        menuBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        addSubview(menuBtn)
        menuBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0).isActive = true
        menuBtn.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0.0).isActive = true
        menuBtn.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        menuBtn.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
    }
    private func showTopMenuIcon() {
        menuBtn.translatesAutoresizingMaskIntoConstraints = false
        setMenuIcon(name: "more_H")
        menuBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        addSubview(menuBtn)
        menuBtn.topAnchor.constraint(equalTo: topAnchor, constant: 10.0).isActive = true
        menuBtn.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0.0).isActive = true
        menuBtn.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        menuBtn.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
    }
    private func showBottomMenuIcon() {
        menuBtn.translatesAutoresizingMaskIntoConstraints = false
        setMenuIcon(name: "more_H")
        menuBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        addSubview(menuBtn)
        menuBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0).isActive = true
        menuBtn.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0.0).isActive = true
        menuBtn.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        menuBtn.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
    }
    private func setupMenuItems(_ tableViewCell: UITableViewCell) {
        guard let items = items else {
            return
        }
        switch menuLayout {
        case .Horizontal, .Vertical:
            for item in items {
              item.setupUI()
              stackView.addArrangedSubview(item)
            }
        case .Square:
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
    
}
//MARK: Alignment and Spacing Methods
extension WBMenuView {
    
    func setMenuContentAlignment(_ alignment: ConentAlignment) {
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
        topSpacing = top
        bottomSpacing = bottom
        leftSpacing =  left
        rightSpacing = right
        setupContentSpacing()
    }
    func setMenuItemSpacingVertical(_ vertical: CGFloat) {
       verticalSpacing = vertical
       setupContentVerticalSpacing()
    }
    func setMenuItemSpacingHorizontal(_ horizontal: CGFloat) {
        horizontalSpacing = horizontal
        setupContentHorizontalSpacing()
    }
}
extension WBMenuView: UIGestureRecognizerDelegate {
    
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

////

//MARK: Item View
class WBMenuItem: UIView {
    
    //MARK: Instance Variables
    private var titleLbl = UILabel(frame: CGRect.zero)
    private var titleImage = UIImageView(frame: CGRect.zero)
    private var actionBtn = UIButton.init(type: UIButtonType.custom)
    private var stackView = UIStackView(frame: CGRect.zero)
    private var action:actionHandler?

    var itemIconSize: CGSize = CGSize(width: 50.0, height: 70.0)
    var titleColor: UIColor? {
        didSet {
            titleLbl.textColor = titleColor
        }
    }
    var itemBorderColor: UIColor? {
        didSet {
            actionBtn.layer.borderColor = itemBorderColor?.cgColor
        }
    }
    var itemBorderWidth: CGFloat? {
        didSet {
            actionBtn.layer.borderWidth = itemBorderWidth ?? 0.0
        }
    }
    var titleFont: UIFont? {
        didSet {
            titleLbl.font = titleFont
        }
    }
    var actionBtnIcon: String? {
        didSet {
            actionBtn.setImage(UIImage(named: actionBtnIcon!), for: .normal)
        }
    }
    
    //MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init(title: String, icon: String, actionHandler: @escaping actionHandler) {
        self.init(frame: CGRect.zero)
        titleLbl.text = title
        titleImage.image = UIImage(named: icon)
        action = actionHandler
        actionBtn.addTarget(self, action: #selector(actionBtnPressed(sender:)), for: .touchUpInside)
       // setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(:coder) is not been implemented")
    }
    
    //MARK: Helper Methods
    func setupUI() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        titleLbl.numberOfLines = 0
        titleLbl.textAlignment = .center
        titleLbl.font = UIFont.systemFont(ofSize: 12.0)
        titleColor = UIColor.black
        titleLbl.textColor = UIColor.black
        
        titleImage.heightAnchor.constraint(equalToConstant: itemIconSize.height).isActive = true
        titleImage.widthAnchor.constraint(equalToConstant: itemIconSize.width).isActive = true
        titleImage.contentMode = .scaleAspectFit
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        addSubview(stackView)
        
        stackView.addArrangedSubview(titleImage)
        stackView.addArrangedSubview(titleLbl)
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        actionBtn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(actionBtn)
        actionBtn.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        actionBtn.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        actionBtn.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        actionBtn.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        
    }
    
    //MARK: Action Methods
    @objc func actionBtnPressed(sender: UIButton) {
        guard let mAction = self.action else {
            return
        }
        mAction(self)
    }
    
}

