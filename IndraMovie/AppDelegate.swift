//
//  AppDelegate.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 22/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import UIKit
import TraktKit
extension Notification.Name {
    static let TraktSignedIn = Notification.Name(rawValue: "TraktSignedIn")
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    //This is a constants for trakingTV
    private struct Constants {
        static let clientId = "dd9c21458971d6f0a7ab55af8feb07120386b1888a9e0775ef40685cfe9be428"
        static let clientSecret = "545968e2a5c858eaa7bdaa538b44aea3c51f8550d3bbcef5008abe6dc04a8352"
        static let redirectURI = "traktkit://auth/trakt"
    }
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//         Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.backgroundColor = UIColor.white
        window!.makeKeyAndVisible()
        
        self.loadRootScene(in:window!)
       
        TraktManager.sharedManager.set(clientID: Constants.clientId,
                                       clientSecret: Constants.clientSecret,
                                       redirectURI: Constants.redirectURI)
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let queryDict = url.queryDict() // Parse URL
        
        if url.host == "auth",
            let code = queryDict["code"] as? String { // Get authorization code
            do {
                try TraktManager.sharedManager.getTokenFromAuthorizationCode(code: code) { result in
                    switch result {
                    case .success:
                        print("Signed in to Trakt")
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: .TraktSignedIn, object: nil)
                        }
                    case .fail:
                        print("Failed to sign in to Trakt")
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        return true
    }
}

extension URL {
    func queryDict() -> [String: Any] {
        var info: [String: Any] = [String: Any]()
        if let queryString = self.query{
            for parameter in queryString.components(separatedBy: "&"){
                let parts = parameter.components(separatedBy: "=")
                if parts.count > 1 {
                    let key = parts[0].removingPercentEncoding
                    let value = parts[1].removingPercentEncoding
                    if key != nil && value != nil{
                        info[key!] = value
                    }
                }
            }
        }
        return info
    }
}
extension AppDelegate {
    func loadRootScene(in window:UIWindow)  {
        let sceneReactive = SceneReactive(window: window)
        let splashViewModel = SplashViewModel(coordinator: sceneReactive)
        let splashScene = Scene.splash(splashViewModel)
        sceneReactive.transition(to: splashScene, type: .root)
    }
}
