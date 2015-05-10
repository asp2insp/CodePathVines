//
//  DetailViewController.swift
//  CodePathVines
//
//  Created by Josiah Gaskin on 5/10/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import Foundation

import UIKit

class DetailViewController: UIViewController, ReactorResponder {

    @IBOutlet weak var hiResImage: UIImageView!
    @IBOutlet weak var lowResImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!

    @IBOutlet weak var synopsis: UITextView!
    let reactor = Reactor.instance

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reactor.responder = self
        self.onUpdate()
    }
    
    
    func onUpdate() {
        let movie = reactor.evaluate(CURRENT_ITEM)
        let fullUrl = movie.getIn(["posters", "original"]).toSwift() as! String
        let index = fullUrl.rangeOfString("dkpu1ddg7pbsk")?.startIndex ?? fullUrl.startIndex
        let origUrl = fullUrl.substringFromIndex(index)
        self.hiResImage.alpha = 0.0
        self.lowResImage.setImageWithURL(NSURL(string:fullUrl))
        let request = NSURLRequest(URL: NSURL(string:"http://\(origUrl)")!)
        self.hiResImage.setImageWithURLRequest(request, placeholderImage: nil, success: { (request, response, freshImage) -> Void in
            self.hiResImage.image = freshImage
            UIView.animateWithDuration(0.5, animations: {
                self.hiResImage.alpha = 1.0
                return
            })
        }, failure: nil)
        self.movieTitle.text = movie.getIn(["title"]).toSwift() as? String ?? "Unknown"
        self.synopsis.text = movie.getIn(["synopsis"]).toSwift() as? String ?? "Unknown"
    }
}
