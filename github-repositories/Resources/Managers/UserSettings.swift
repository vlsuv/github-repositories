//
//  UserSettings.swift
//  github-repositories
//
//  Created by vlsuv on 05.08.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class UserSettings {
    
    private init() {}
    
    static var shared = UserSettings()
    
    enum settingKeys: String {
        case downloads
    }
    
    var downloads: [Download] {
        get {
            guard let decoded  = UserDefaults.standard.object(forKey: settingKeys.downloads.rawValue) as? Data, let value = try? JSONDecoder().decode([Download].self, from: decoded) else { return [] }
            
            return value
        }
        set {
            let defaults = UserDefaults.standard
            let key = settingKeys.downloads.rawValue
            
            if let encoded = try? JSONEncoder().encode(newValue) {
                defaults.set(encoded, forKey: key)
            }
            
        }
    }
}
