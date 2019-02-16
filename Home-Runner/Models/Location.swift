//
//  Location.swift
//  Home-Runner
//
//  Created by Andrii Zakharenkov on 2/16/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import Foundation
import RealmSwift

class Location: Object {
    @objc dynamic public private(set) var lat = 0.0
    @objc dynamic public private(set) var long = 0.0
    
    convenience init(lat: Double, long: Double) {
        self.init()
        self.lat = lat
        self.long = long
    }
}
