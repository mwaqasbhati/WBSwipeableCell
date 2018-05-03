//
//  WBMenuItem.swift
//  WBSwipeToOptionCell
//
//  Created by MacBook on 4/28/18.
//  Copyright © 2018 Waqas Sultan. All rights reserved.
//

import UIKit

//MARK: Item View

class MenuItem: UIView {
    
    //MARK: Instance Variables
    
    private var titleLbl = UILabel(frame: .zero)
    private var titleImage = UIImageView(frame: .zero)
    private var actionBtn = UIButton.init(type: .custom)
    private var stackView = UIStackView(frame: .zero)
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
    
    //MARK: Initializers
    
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
