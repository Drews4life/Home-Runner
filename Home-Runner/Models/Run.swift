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
    public private(set) var locations = List<Location>()

    override class func primaryKey() -> String {
        return "id"
    }
    
    override class func indexedProperties() -> [String] {
        return ["date", "pace", "duration"]
    }
    
    convenience init(pace: Int, distance: Double, duration: Int, locations: List<Location>) {
        self.init()
        self.id = UUID().uuidString.lowercased()
        self.pace = pace
        self.distance = distance
        self.duration = duration
        self.date = NSDate()
        self.locations = locations
    }
    
    static func saveRunToRealm(pace: Int, distance: Double, duration: Int, locations: List<Location>) {
        REALM_QUEUE.sync {
            let run = Run(pace: pace, distance: distance, duration: duration, locations: locations)
            
            do {
                let realm = try Realm(configuration: RealmConfig.runDataConfig)
                
                try realm.write {
                    realm.add(run)
                    try realm.commitWrite()
                }
            } catch {
                debugPrint("Realm saving error: \(error.localizedDescription)")
            }

        }
    }
    
    static func retrieveAllRuns() -> Results<Run>? {
        do {
            let realm = try Realm(configuration: RealmConfig.runDataConfig)
            
            var runs = realm.objects(Run.self)
            runs = runs.sorted(byKeyPath: "date", ascending: false)
            return runs;
        } catch {
            debugPrint("Could not retrieve data: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func retrieveRun(forId id: String) -> Run? {
        do {
            let realm = try Realm(configuration: RealmConfig.runDataConfig)
            
            let run = realm.object(ofType: Run.self, forPrimaryKey: id)
            
            return run
        } catch {
            debugPrint("Could not retrieve single Run by id: \(error.localizedDescription)")
            return nil
        }
    }
}
