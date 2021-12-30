//
//  AppDelegate.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 22/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.backgroundColor = UIColor.white
        window!.makeKeyAndVisible()
        
        self.loadRootScene(in:window!)
        
        return true
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
