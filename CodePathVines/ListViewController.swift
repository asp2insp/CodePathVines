//
//  FirstViewController.swift
//  CodePathVines
//
//  Created by Josiah Gaskin on 5/4/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITabBarDelegate, ReactorResponder {
    let reactor = Reactor.instance
    
    @IBOutlet weak var BoxOfficeItem: UITabBarItem!
    @IBOutlet weak var DVDItem: UITabBarItem!
    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var tableView: UITableView!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.rowHeight = 97
        reactor.responder = self
        refreshDataFromServer()
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reactor.evaluate(BOX_OR_DVDS).count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("asp2insp.codepathvines.movie", forIndexPath: indexPath) as! MovieViewCell
        cell.title.text = reactor.evaluate(BOX_OR_DVDS).getIn([indexPath.row, "title"]).toSwift() as? String ?? "Unknown"
        let url = reactor.evaluate(BOX_OR_DVDS).getIn([indexPath.row, "posters", "profile"]).toSwift() as? String ?? ""
        cell.poster.setImageWithURL(NSURL(string:url))
        return cell
    }
    
    func onUpdate() {
        let currentCategory = reactor.evaluateToSwift(CURRENT_CATEGORY) as! String
        if currentCategory == "boxoffice" {
            tabbar.selectedItem = BoxOfficeItem
        } else {
            tabbar.selectedItem = DVDItem
        }
        self.tableView.reloadData()
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        if item == DVDItem {
            reactor.dispatch("setCategory", payload: "dvds")
        } else {
            reactor.dispatch("setCategory", payload: "boxoffice")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let path = self.tableView.indexPathForSelectedRow()!
        reactor.dispatch("setCurrentIndex", payload: path.row)
    }
}

// Custom cell
class MovieViewCell:UITableViewCell {
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: UILabel!
}
