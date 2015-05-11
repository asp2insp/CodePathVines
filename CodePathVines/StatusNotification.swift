//
//  StatusNotification.swift
//  CodePathVines
//
//  Created by Josiah Gaskin on 5/10/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import Foundation


public class StatusNotification : UIView, ReactorResponder {
    var lastNetworkState : Bool = true
    public func onUpdate() {
        let networkOn = Reactor.instance.evaluateToSwift(NETWORK_STATUS) as? Bool ?? false
        if lastNetworkState != networkOn {
            let targetHeight : CGFloat = networkOn ? 0.0 : 50.0
            var frame = self.frame
            UIView.animateWithDuration(0.5, animations: {
                self.frame = CGRectMake(frame.minX, frame.minY, frame.width, targetHeight)
                self.hidden = networkOn
                return
            })
            lastNetworkState = networkOn
        }
    }
}