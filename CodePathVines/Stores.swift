//
//  Stores.swift
//  CodePathVines
//
//  Created by Josiah Gaskin on 5/9/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import Foundation

class MovieDataStore : Store {
    override func getInitialState() -> Immutable.State {
        return Immutable.toState([:])
    }
    
    override func initialize() {
        self.on("addItem", handler: {(state, payload, action) -> Immutable.State in
            let item = payload as! [String:NSObject]
            let name : AnyObject = item["name"] ?? "unknown"
            let price : AnyObject = item["price"] ?? -1
            return state.mutateIn(["all"], withMutator: { (items) in
                return items!.push(Immutable.toState(["name": name, "price": price]))
            })
        })
    }
}