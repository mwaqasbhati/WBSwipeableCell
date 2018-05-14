# WBSwipeableCell


SwipeableMenu works well for both UITableViewCell and UICollectionViewCell, implemented in Swift.*


## About

A swipeable Menu has below mentioned features:

* Left and right swipe actions
* Menu Action button with: image only*
* Menu Style: *Horizontal, Square and Vertical*
* Animated expansion from left, right, top and bottom
* Custom Menu: Alignment, Menu Style and direction
* Custom Menu Items: title text and Image

## Background

I have used many menus for a tableviewcell and collectionviewcell but WBSwipeableCell is used where we have lengthy number of menu items and needs to display in one view.

## Demo

### Menu Styles

The transition style describes how the action buttons are exposed during the swipe.

|             Horizontal Layout         |         Square Layout          | Vertical Layout | 
|---------------------------------|------------------------------|------------------------------|
|![Demo](https://github.com/mwaqasbhati/WBSwipeableCell/blob/master/Screenshots/horizontal-right.gif)|![Demo](https://github.com/mwaqasbhati/WBSwipeableCell/blob/master/Screenshots/square.gif)|![Demo](https://github.com/mwaqasbhati/WBSwipeableCell/blob/master/Screenshots/vertical.gif)

#### Horizontal 

For Horizontal menu layout, we need to implement one optional delegate method of `MenuViewDelegate` protocol which is given below

````swift
func menuView(_ view: MenuView, menuLayoutForRowAtIndexPath indexPath: IndexPath) -> MenuLayout {
     return .horizontal
}
````

#### Vertical 

For Vertical menu layout, we need to implement one optional delegate method of `MenuViewDelegate` protocol which is given below

````swift
func menuView(_ view: MenuView, menuLayoutForRowAtIndexPath indexPath: IndexPath) -> MenuLayout {
     return .vertical
}
````

#### Square 

For Square menu layout, we need to implement one optional delegate method of `MenuViewDelegate` protocol which is given below

````swift
func menuView(_ view: MenuView, menuLayoutForRowAtIndexPath indexPath: IndexPath) -> MenuLayout {
     return .square
}
````

### Expansion Styles

The expansion style describes the behavior when we call the `open` and `close` function of Menu View. 

|             Left         |         Right          | Top | Bottom |
|---------------------------------|------------------------------|------------------------------|---------------------------------|
|![Demo](https://github.com/mwaqasbhati/WBSwipeableCell/blob/master/Screenshots/horizontal-left.gif)|![Demo](https://github.com/mwaqasbhati/WBSwipeableCell/blob/master/Screenshots/horizontal-right.gif)|![Demo](https://github.com/mwaqasbhati/WBSwipeableCell/blob/master/Screenshots/horizontal-top.gif)|![Demo](https://github.com/mwaqasbhati/WBSwipeableCell/blob/master/Screenshots/horizontal-bottom.gif)|

#### Left

Expansion from the left side of the cell we need to implement one optinal method of 'MenuViewDelegate' protocol which is given below

````swift
func menuView(_ menuview: MenuView, directionForRowAtIndexPath indexPath: IndexPath) -> Direction {
     return .left
}
````


#### Right

Expansion from the right side of the cell we need to implement one optinal method of 'MenuViewDelegate' protocol which is given below

````swift
func menuView(_ menuview: MenuView, directionForRowAtIndexPath indexPath: IndexPath) -> Direction {
     return .right
}
````


#### Top

Expansion from the top side of the cell we need to implement one optinal method of 'MenuViewDelegate' protocol which is given below

````swift
func menuView(_ menuview: MenuView, directionForRowAtIndexPath indexPath: IndexPath) -> Direction {
     return .top
}
````


#### Bottom

Expansion from the bottom side of the cell we need to implement one optinal method of 'MenuViewDelegate' protocol which is given below

````swift
func menuView(_ menuview: MenuView, directionForRowAtIndexPath indexPath: IndexPath) -> Direction {
     return .bottom
}
````

### Menu Icon show/hide & Dimension

* If we want to show/hide icon, we need to implement below mentiond protocol method. It will show/hide based on the method return type value.

````swift
func menuView(_ menuview: MenuView, showMenuIconForRowAtIndexPath indexPath: IndexPath) -> Bool {
     return true
}
````

* Below mentioned protocol method controls the position of the menu icon that will be left, right, top, bottom.

````swift
func menuView(_ menuview: MenuView, positionOfMenuIconForRowAtIndexPath indexPath: IndexPath) -> Direction {
     return .top
}
````

### Menu View

we can customize menu View with the below mentioned functions.

````swift
let menu = MenuView(mCell: cell, items: [], indexPath: indexPath)
menu.setMenuContentAlignment(.center)
menu.setBgColor(UIColor(red: 90.0/255.0, green: 200.0/255.0, blue: 250.0/255.0, alpha: 1.0))
menu.setMenuItemSpacingVertical(5.0)
menu.setMenuItemSpacingHorizontal(15.0)
menu.setMenuContentInset(10, left: 10, bottom: 10, right: -10)
````

### Menu Items

we can customize each menu item with the below mentioned functions.

````swift
let firstItem = MenuItem(title: "Delete", icon: "delete") { (item) in
}
firstItem.itemBorderColor = UIColor.white
firstItem.itemBorderWidth = 2.0
firstItem.itemIconSize = CGSize(width: 50, height: 30)
firstItem.titleColor = UIColor.gray
firstItem.titleFont = UIFont.systemFont(ofSize: 11.0)
firstItem.backgroundColor = UIColor.blue
````

## Requirements

* Swift 4.0
* Xcode 9+
* iOS 9.0+

## Installation

#### [CocoaPods](http://cocoapods.org) (recommended)

````ruby
use_frameworks!

# Latest release in CocoaPods
pod 'WBSwipeableCell'

````

## Usage

You need to add below mentioned code in `cellForRowAt` for UITableView or `cellForItemAt` for UICollectionView

````swift
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let firstItem = MenuItem(title: "Delete", icon: "delete") { (item) in
          // Menu Item click Handler
      }
      let secondItem = MenuItem(title: "Submit", icon: "save"){ (item) in
          // Menu Item click Handler
      }
      let thirdItem = MenuItem(title: "Save", icon: "submit"){ (item) in
          // Menu Item click Handler
      }
      let fourthItem = MenuItem(title: "Edit", icon: "edit"){ (item) in
          // Menu Item click Handler
      }
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
      let menu = MenuView(mCell: cell, items: [firstItem, secondItem, thirdItem, fourthItem], indexPath: indexPath)
      menu.delegate = self
      return cell
}
````

````swift
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let firstItem = MenuItem(title: "Delete", icon: "delete") { (item) in
                  // Menu Item click Handler
        }
        let secondItem = MenuItem(title: "Submit", icon: "save"){ (item) in
                  // Menu Item click Handler
        }
        let thirdItem = MenuItem(title: "Save", icon: "submit"){ (item) in
                  // Menu Item click Handler
        }
        let fourthItem = MenuItem(title: "Edit", icon: "edit"){ (item) in
                  // Menu Item click Handler
        }

        let menu = MenuView(mCell: cell, items: [firstItem, secondItem, thirdItem, fourthItem], indexPath: indexPath)
        menu.delegate = self
        return cell
    }
````

### MenuViewDelegate

Adopt the `MenuViewDelegate` protocol:

````swift
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
````

## Author

mwaqasbhati, m.waqas.bhati@hotmail.com

## License

WBSwipeableCell is available under the MIT license. See the LICENSE file for more info.
