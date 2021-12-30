//
//  Configuration.swift
//  App
//
//  Created by Jordy Aguilar on 8/09/21.
//

import UIKit

class Configuration {
    var basePath: String = ""
    var scheme: String = ""
    public static func configurationValueForKeyAndSubKey(
        key: String,
        subKey: String,
        baseConfigurationDictionary: [String: Any] ) -> Any? {
        if let keyDictionary: [String: Any] = baseConfigurationDictionary[key] as? [String: Any] {
            if let enviromentDictionary: Dictionary = keyDictionary[subKey] as? [String: Any] {
                return enviromentDictionary[BuildConfiguration.shared.environment.rawValue] as Any
            } else {
                return keyDictionary[subKey] as Any
            }
        }
        return nil
    }
}
