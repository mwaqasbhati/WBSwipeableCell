# WBSwipeableCell


* SwipeableMenu works well for both UITableViewCell and UICollectionViewCell, implemented in Swift.*


## About

A swipeable Menu has below mentioned features:

* Left and right swipe actions
* Menu Action button with: image only*
* Menu Style: *Horizontal, Square and Vertical*
* Animated expansion from left, right, top and bottom
* Custom Menu: Alignment, Menu Style and direction
* Custom Menu Items: title text and Image

## Background

I have used many menus for a tableviewcell and collectionviewcell but WBSwipeableCell could be used if our menu goes bigger in menu items.

## Demo

### Menu Styles

The transition style describes how the action buttons are exposed during the swipe.

|             Horizontal Layout         |         Square Layout          | Vertical Layout | 
|---------------------------------|------------------------------|------------------------------|
|![Demo](https://github.com/mwaqasbhati/WBSwipeableCell/blob/master/Screenshots/horizontal-right.gif)|![Demo](https://github.com/mwaqasbhati/WBSwipeableCell/blob/master/Screenshots/square.gif)|![Demo](https://github.com/mwaqasbhati/WBSwipeableCell/blob/master/Screenshots/vertical.gif)

#### Horizontal 


#### Vertical 


#### Square 



### Expansion Styles

The expansion style describes the behavior when the cell is swiped past a defined threshold.

|             Left         |         Right          | Top | Bottom |
|---------------------------------|------------------------------|------------------------------|---------------------------------|
|![Demo](https://github.com/mwaqasbhati/WBSwipeableCell/blob/master/Screenshots/horizontal-left.gif)|![Demo](https://github.com/mwaqasbhati/WBSwipeableCell/blob/master/Screenshots/horizontal-right.gif)|![Demo](https://github.com/mwaqasbhati/WBSwipeableCell/blob/master/Screenshots/horizontal-top.gif)|![Demo](https://github.com/mwaqasbhati/WBSwipeableCell/blob/master/Screenshots/horizontal-bottom.gif)|

#### Left


#### Right


#### Top


#### Bottom


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

## Usage

You need to add below mentioned code in 'cellForRowAt' like below

````swift
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let firstItem = MenuItem(title: "Delete", icon: "delete") { (item) in
          // button click
      }
      let secondItem = MenuItem(title: "Submit", icon: "save"){ (item) in
         // button click
      }
      let thirdItem = MenuItem(title: "Save", icon: "submit"){ (item) in
         // button click 
      }
      let fourthItem = MenuItem(title: "Edit", icon: "edit"){ (item) in
         // button click
      }
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
      let menu = MenuView(mCell: cell, items: [firstItem, secondItem, thirdItem, fourthItem], indexPath: indexPath)
      menu.delegate = self
      return cell
}
````

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
