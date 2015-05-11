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
            "currentIndex": 0,
            "networkStatus": true
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
        self.on("setNetworkStatus", handler: {(state, payload, action) -> Immutable.State in
            let newStatus = payload as! Bool
            return state.setIn(["networkStatus"], withValue: Immutable.toState(newStatus))
        })
    }
}

public let CURRENT_CATEGORY = Getter(keyPath: ["ui", "currentCategory"])
public let BOX_OR_DVDS = Getter(keyPath: [CURRENT_CATEGORY, "data"], withFunc: { (args) -> Immutable.State in
    let categoryName = args[0].toSwift() as! String
    return args[1].getIn([categoryName, "movies"]).map({(state, index) -> Immutable.State in
        return state.setIn(["index"], withValue: Immutable.toState(index))
    })
})
public let FILTERED_ITEMS = Getter(keyPath: [BOX_OR_DVDS, "ui", "searchTerm"], withFunc: {(args) -> Immutable.State in
    let filterTerm = args[1].toSwift() as! String
    return args[0].filter({(movie) -> Bool in
        return count(filterTerm) == 0 || (movie.getIn(["title"]).toSwift() as! NSString).localizedCaseInsensitiveContainsString(filterTerm)
    })
})
public let CURRENT_ITEM = Getter(keyPath: [BOX_OR_DVDS, "ui", "currentIndex"], withFunc: {(args) -> Immutable.State in
    let index = args[1].toSwift() as! Int
    return args[0].getIn([index])
})
public let NETWORK_STATUS = Getter(keyPath: ["ui", "networkStatus"])