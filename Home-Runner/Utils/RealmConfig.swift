//
//  RealmConfig.swift
//  Home-Runner
//
//  Created by Andrii Zakharenkov on 2/16/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import Foundation
import RealmSwift

class RealmConfig {
    static var runDataConfig: Realm.Configuration {
        let realmPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(REALM_RUN_CONFIGURATION)
        let config = Realm.Configuration(
            fileURL: realmPath,
            schemaVersion: 0,
            migrationBlock: { (migration, oldSchema) in
                if oldSchema < 0 {
                    //realm will automatically detect new props and remove then
                }
        })
        
        return config
    }
}
