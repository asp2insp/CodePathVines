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
    @IBOutlet weak var image: UIImageView!
    let reactor = Reactor.instance

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reactor.responder = self
        self.onUpdate()
    }
    
    
    func onUpdate() {
        let fullUrl = reactor.evaluate(CURRENT_ITEM).getIn(["posters", "original"]).toSwift() as! String
        let index = fullUrl.rangeOfString("dkpu1ddg7pbsk")?.startIndex ?? fullUrl.startIndex
        let origUrl = fullUrl.substringFromIndex(index)
        println(origUrl)
        image.setImageWithURL(NSURL(string:"http://\(origUrl)"))
    }
}
