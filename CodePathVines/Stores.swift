//
//  Stores.swift
//  CodePathVines
//
//  Created by Josiah Gaskin on 5/9/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import Foundation

// ID: data
public class MovieDataStore : Store {
    override func getInitialState() -> Immutable.State {
        return Immutable.toState([:])
    }
    
    override func initialize() {
        self.on("setDvds", handler: {(state, payload, action) -> Immutable.State in
            return state.setIn(["dvds"], withValue: Immutable.toState(payload as! AnyObject))
        })
        self.on("setBoxOffice", handler: {(state, payload, action) -> Immutable.State in
            return state.setIn(["boxoffice"], withValue: Immutable.toState(payload as! AnyObject))
        })
    }
}

// ID: ui
public class UIStateStore : Store {
    override func getInitialState() -> Immutable.State {
        let startData = [
            "searchTerm": "",
            "listType": "list", // list or grid
            "currentCategory": "boxoffice", // boxoffice or dvds
            "currentIndex": 0
        ]
        return Immutable.toState(startData)
    }
    
    override func initialize() {
        self.on("updateSearch", handler: {(state, payload, action) -> Immutable.State in
            let newSearch = payload as! String
            return state.setIn(["searchTerm"], withValue: Immutable.toState(newSearch))
        })
        self.on("toggleListGrid", handler: {(state, payload, action) -> Immutable.State in
            let currentView = state.getIn(["listType"]).toSwift() as! String
            let newView = currentView == "list" ? "grid" : "list"
            return state.setIn(["listType"], withValue: Immutable.toState(newView))
        })
        self.on("setCategory", handler: {(state, payload, action) -> Immutable.State in
            let newCategory = payload as! String
            return state.setIn(["currentCategory"], withValue: Immutable.toState(newCategory))
        })
        self.on("setCurrentIndex", handler: {(state, payload, action) -> Immutable.State in
            let newIndex = payload as! Int
            return state.setIn(["currentIndex"], withValue: Immutable.toState(newIndex))
        })
    }
}

public let CURRENT_CATEGORY = Getter(keyPath: ["ui", "currentCategory"])
public let CURRENT_INDEX = Getter(keyPath: ["ui", "currentIndex"])
public let BOX_OR_DVDS = Getter(keyPath: [CURRENT_CATEGORY, "data"], withFunc: { (args) -> Immutable.State in
    let categoryName = args[0].toSwift() as! String
    return args[1].getIn([categoryName, "movies"])
})
public let FILTERED_ITEMS = Getter(keyPath: [BOX_OR_DVDS, "ui", "searchTerm"], withFunc: {(args) -> Immutable.State in
    let filterTerm = args[1].toSwift() as! String
    return args[0].filter({(movie) -> Bool in
        return count(filterTerm) > 0 && (movie.getIn(["title"]).toSwift() as! String).rangeOfString(filterTerm) != nil
    })
})
