//
//  BuildConfiguration.swift
//  App
//
//  Created by Jordy Aguilar on 7/09/21.
//

import UIKit

enum Environment: String {
    case debugDevelopment = "Debug Dev"
    case debug = "Debug"
    case release = "Release"
    case releaseDev = "Release Dev"
}

class BuildConfiguration {
    static let shared = BuildConfiguration()
    var environment: Environment

    init() {
        let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String

        environment = Environment(rawValue: currentConfiguration!)!
    }
}
