//
//  FirstViewController.swift
//  CodePathVines
//
//  Created by Josiah Gaskin on 5/4/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController, ReactorResponder {
    let reactor = Reactor.instance
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reactor.responder = self
        refreshDataFromServer()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reactor.evaluate(BOX_OR_DVDS).count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("asp2insp.codepathvines.movie", forIndexPath: indexPath) as! MovieViewCell
        cell.title.text = reactor.evaluate(BOX_OR_DVDS).getIn([indexPath.row, "title"]).toSwift() as? String ?? "Unknown"
        let url = reactor.evaluate(BOX_OR_DVDS).getIn([indexPath.row, "posters", "profile"]).toSwift() as? String ?? ""
        cell.poster.setImageWithURL(NSURL(string:url))
        return cell
    }
    
    func onUpdate() {
        self.tableView.reloadData()
    }
}

// Custom cell
class MovieViewCell:UITableViewCell {
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: UILabel!
}
