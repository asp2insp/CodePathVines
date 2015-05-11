//
//  Network.swift
//  CodePathVines
//
//  Created by Josiah Gaskin on 5/9/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import Foundation

let manager = AFHTTPRequestOperationManager()

public func refreshDataFromServer() {
    manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/plain") as Set<NSObject>
    manager.GET("https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json", parameters: nil, success: { (operation, data) -> Void in
            Reactor.instance.dispatch("setNetworkStatus", payload: true)
            Reactor.instance.dispatch("setDvds", payload: data)
        }) { (operation, error) -> Void in
            Reactor.instance.dispatch("setNetworkStatus", payload: false)
            println(error.localizedDescription)
    }
    manager.GET("https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json", parameters: nil, success: { (operation, data) -> Void in
            Reactor.instance.dispatch("setNetworkStatus", payload: true)
            Reactor.instance.dispatch("setBoxOffice", payload: data)
        }) { (operation, error) -> Void in
            Reactor.instance.dispatch("setNetworkStatus", payload: false)
            println(error.localizedDescription)
    }
}