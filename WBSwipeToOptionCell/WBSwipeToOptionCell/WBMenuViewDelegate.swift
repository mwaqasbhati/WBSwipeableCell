//
//  WBMenuViewDelegate.swift
//  WBSwipeToOptionCell
//
//  Created by MacBook on 4/28/18.
//  Copyright © 2018 Waqas Bhati. All rights reserved.
//

import UIKit

/**
 This Protocol will be used to create layout with specifications for the class who will implement it by conforming.
 
 - function directionForRowAtIndexPath: 
 */

protocol MenuViewDelegate: class {
    func menuView(_ menuview: MenuView, directionForRowAtIndexPath indexPath: IndexPath) -> Direction
    func menuView(_ menuview: MenuView, menuLayoutForRowAtIndexPath indexPath: IndexPath) -> MenuLayout
    func menuView(_ menuview: MenuView, showMenuIconForRowAtIndexPath indexPath: IndexPath) -> Bool
    func menuView(_ menuview: MenuView, positionOfMenuIconForRowAtIndexPath indexPath: IndexPath) -> Direction
}

extension MenuViewDelegate {
    func menuView(_ menuview: MenuView, directionForRowAtIndexPath indexPath: IndexPath) -> Direction {
        return .bottom
    }
    func menuView(_ menuview: MenuView, menuLayoutForRowAtIndexPath indexPath: IndexPath) -> MenuLayout {
        return .horizontal
    }
    func menuView(_ menuview: MenuView, showMenuIconForRowAtIndexPath indexPath: IndexPath) -> Bool {
        return true
    }
    func menuView(_ menuview: MenuView, positionOfMenuIconForRowAtIndexPath indexPath: IndexPath) -> Direction {
        return .top
    }
}
