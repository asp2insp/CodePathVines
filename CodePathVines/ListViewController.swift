//
//  FirstViewController.swift
//  CodePathVines
//
//  Created by Josiah Gaskin on 5/4/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITabBarDelegate, UISearchBarDelegate, ReactorResponder {
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
        return reactor.evaluate(FILTERED_ITEMS).count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("asp2insp.codepathvines.movie", forIndexPath: indexPath) as! MovieViewCell
        cell.title.text = reactor.evaluate(FILTERED_ITEMS).getIn([indexPath.row, "title"]).toSwift() as? String ?? "Unknown"
        let url = reactor.evaluate(FILTERED_ITEMS).getIn([indexPath.row, "posters", "profile"]).toSwift() as? String ?? ""
        let request = NSURLRequest(URL: NSURL(string:url)!)
        cell.poster.setImageWithURLRequest(request, placeholderImage: nil, success: { (request, response, freshImage) -> Void in
            let shouldAnimate = cell.poster.image == nil || cell.poster.image != freshImage
            cell.poster.image = freshImage
            if shouldAnimate {
                cell.poster.alpha = 0.0
                UIView.animateWithDuration(0.5, animations: {
                    cell.poster.alpha = 1.0
                    return
                })
            }
            }, failure: { (request, response, error) -> Void in
                cell.poster.image = nil
        })
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
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        reactor.dispatch("updateSearch", payload: searchText)
    }
}

// Custom cell
class MovieViewCell:UITableViewCell {
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: UILabel!
}
