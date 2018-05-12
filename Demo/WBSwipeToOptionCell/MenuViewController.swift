//
//  MenuViewController.swift
//  WBSwipeToOptionCell
//
//  Created by MacBook on 5/12/18.
//  Copyright © 2018 Waqas Sultan. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var menuTableView: UITableView!
    
    private let sectionsDS = [["Vertical Menu", "Square Menu", "Horizontal Menu"], ["Horizontal Menu - Left", "Horizontal Menu - Right", "Horizontal Menu - Top", "Horizontal Menu - Bottom"]]
    private let layouts: [[MenuLayout]] = [[.vertical, .square, .horizontal], [.horizontal, .horizontal, .horizontal, .horizontal]]
    private let directions: [[Direction]] = [[.right, .right, .right], [.left, .right, .top, .bottom]]
    private let sequeIdentifiers = ["goToCollectionVC", "goToTableVC"]
    private let headerTitles = ["Collection View", "Table View"]
    private var selectedIndex = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? ViewController {
            dest.setMenuLayout(layouts[selectedIndex.section][selectedIndex.row])
            dest.setMenuDirection(directions[selectedIndex.section][selectedIndex.row])
        } else if let dest = segue.destination as? CollectionViewController {
            dest.setMenuLayout(layouts[selectedIndex.section][selectedIndex.row])
            dest.setMenuDirection(directions[selectedIndex.section][selectedIndex.row])
        }
    }
    

}
extension MenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         selectedIndex = indexPath
         performSegue(withIdentifier: sequeIdentifiers[selectedIndex.section], sender: nil)
    }
}
extension MenuViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsDS[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellID") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = sectionsDS[indexPath.section][indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitles[section]
    }
}
