//
//  Run.swift
//  Home-Runner
//
//  Created by Andrii Zakharenkov on 2/16/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import Foundation
import RealmSwift

class Run: Object {
    @objc dynamic public private(set) var id = ""
    @objc dynamic public private(set) var pace = 0
    @objc dynamic public private(set) var distance = 0.0
    @objc dynamic public private(set) var duration = 0
    @objc dynamic public private(set) var date = NSDate()

    override class func primaryKey() -> String {
        return "id"
    }
    
    override class func indexedProperties() -> [String] {
        return ["date", "pace", "duration"]
    }
    
    convenience init(pace: Int, distance: Double, duration: Int) {
        self.init()
        self.id = UUID().uuidString.lowercased()
        self.pace = pace
        self.distance = distance
        self.duration = duration
        self.date = NSDate()
    }
}
