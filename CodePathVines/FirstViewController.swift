//
//  FirstViewController.swift
//  CodePathVines
//
//  Created by Josiah Gaskin on 5/4/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource {

    @IBOutlet var moviesTableView: UITableView!
    var moviesDictionaries:[NSDictionary]?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setupApi()
    }
    
    func setupApi() {
        let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?api_key=wp4fesgp4qv2as7ku9bhwezd"
        let request = NSMutableURLRequest(URL: NSURL(string: RottenTomatoesURLString)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(),
            completionHandler: { (response, data, error) in
                if let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary {
                    self.moviesDictionaries = dictionary["movies"] as? [NSDictionary] ?? []
                } else {
                    // Display empty
                }
//                self.moviesTableView.reloadData()
            })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesDictionaries?.count ?? 0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
// configure        segue.destinationViewController
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier:nil)
        let movieDictionary = self.moviesDictionaries![indexPath.row]
        cell.textLabel?.text = movieDictionary["title"] as? String
        return cell
    }
}

// Custom cells
class MyCell:UITableViewCell {
    
}
