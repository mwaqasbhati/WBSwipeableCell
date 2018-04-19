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

enum WBGesture {
    case Swipe
    case Pan
}

class WBMenuItem: UIView {
    
    //MARK: Instance Variables
    private var titleLbl = UILabel(frame: CGRect.zero)
    private var titleImage = UIImageView(frame: CGRect.zero)
    private var actionBtn = UIButton.init(type: UIButtonType.custom)
    private var stackView = UIStackView(frame: CGRect.zero)
    private var action:actionHandler?
    
    //MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init(title: String, icon: String, action: @escaping actionHandler) {
        self.init(frame: CGRect.zero)
        self.titleLbl.text = title
        self.titleImage.image = UIImage(named: icon)
        self.action = action
        self.actionBtn.addTarget(self, action: #selector(actionBtnPressed(sender:)), for: .touchUpInside)
        self.setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(:coder) is not been implemented")
    }
    
    //MARK: Helper Methods
    private func setupUI() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        titleLbl.numberOfLines = 0
        titleLbl.textAlignment = .center
        titleLbl.textColor = UIColor.black
        
        titleImage.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
        titleImage.widthAnchor.constraint(equalToConstant: 70.0).isActive = true
        titleImage.contentMode = .scaleAspectFit
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        self.addSubview(stackView)

        stackView.addArrangedSubview(titleImage)
        stackView.addArrangedSubview(titleLbl)
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        actionBtn.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(actionBtn)
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

class WBMenuView: UIView {
    
    //MARK: Instance Variables
    private var items: [WBMenuItem]?
    private var stackView = UIStackView(frame: CGRect.zero)
    private var tableViewCell: UITableViewCell?
    private var leadingConstraint: NSLayoutConstraint?
    private var menuBtn = UIButton.init(type: UIButtonType.custom)
    private var _isMenuOpen = false
    var isMenuOpen: Bool {
        return _isMenuOpen
    }

    public var swipeGesture: WBGesture! {
        didSet {
            guard let tableViewCell = self.tableViewCell else {
                return
            }
            switch swipeGesture {
            case .Swipe:
                tableViewCell.addGestureRecognizer(swipeLeftGestureRecognizer)
                tableViewCell.addGestureRecognizer(swipeRightGestureRecognizer)
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
        guard let tableViewCell = self.tableViewCell, let leadingConstraint = self.leadingConstraint else {
            return
        }
        let translation = gesture.translation(in: tableViewCell)
        let newX = leadingConstraint.constant + translation.x
        if newX >= -self.frame.size.width && newX <= 0.0 {
            leadingConstraint.constant = newX
            gesture.setTranslation(CGPoint.zero, in: tableViewCell)
        }
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) {
        
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.left:
              self.open()
        case UISwipeGestureRecognizerDirection.right:
            self.close()
            
            
        default: break
            
        }
    }
    func open() {
        guard let leadingConstraint = self.leadingConstraint  else {
            return
        }
        _isMenuOpen = true
        leadingConstraint.constant = -self.frame.size.width
        UIView.animate(withDuration: 1.0) {
            self.tableViewCell?.layoutIfNeeded()
        }
    }
    func close() {
        guard let leadingConstraint = self.leadingConstraint  else {
            return
        }
        _isMenuOpen = false
        leadingConstraint.constant = 0.0
        UIView.animate(withDuration: 1.0) {
            self.tableViewCell?.layoutIfNeeded()
        }
    }
    //MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init(tableViewCell: UITableViewCell, items: [WBMenuItem], gesture: WBGesture? = .Swipe) {
        self.init(frame: CGRect.zero)
        self.tableViewCell = tableViewCell
        self.items = items
        self.menuBtn.addTarget(self, action: #selector(menuBtnPressed(sender:)), for: .touchUpInside)
        self.setupUI()
        defer {
            self.swipeGesture = gesture
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(:coder) is not been implemented")
    }
    
    //MARK: Helper Methods
    func setMenuIcon(name: String) {
        self.menuBtn.setImage(UIImage(named: name), for: .normal)
    }
    static func addOptionsView(tableViewCell: UITableViewCell,_ items: [WBMenuItem]) {
        _ = WBMenuView(tableViewCell: tableViewCell, items: items)
    }
    private func setupUI() {
        guard let tableViewCell = self.tableViewCell else {
            return
        }
        
        self.backgroundColor = UIColor.brown
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.menuBtn.translatesAutoresizingMaskIntoConstraints = false
        self.setMenuIcon(name: "more")
        self.menuBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.addSubview(self.menuBtn)
        self.menuBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0).isActive = true
        self.menuBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
        self.menuBtn.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        self.menuBtn.widthAnchor.constraint(equalToConstant: 20.0).isActive = true

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .horizontal
        self.addSubview(stackView)
        
        for item in self.items! {
            stackView.addArrangedSubview(item)
        }
        
        tableViewCell.addSubview(self)
        
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 0.0).isActive = true
        stackView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: 0.0).isActive = true
        stackView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        leadingConstraint = self.leadingAnchor.constraint(equalTo: tableViewCell.trailingAnchor)
        leadingConstraint?.isActive = true
        self.widthAnchor.constraint(equalTo: tableViewCell.widthAnchor, constant: 0.0).isActive = true
        self.topAnchor.constraint(equalTo: tableViewCell.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: tableViewCell.bottomAnchor).isActive = true
    }
    
    //MARK: Action Methods
    @objc func menuBtnPressed(sender: UIButton) {
        if _isMenuOpen {
            self.close()
        } else {
            self.open()
        }
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
        guard let tableViewCell = self.tableViewCell else {
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

