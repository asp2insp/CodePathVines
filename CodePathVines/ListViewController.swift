//
//  FirstViewController.swift
//  CodePathVines
//
//  Created by Josiah Gaskin on 5/4/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setupApi()
    }
    
    func setupApi() {
        // TODO: Load from network here
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("asp2insp.codepathvines.movie", forIndexPath: indexPath) as! MovieViewCell
        
//        cell.displayImage.setImageWithURL(self.feedUrls[indexPath.row] ?? nil)
        
        return cell
    }
}

// Custom cell
class MovieViewCell:UITableViewCell {
    
}
