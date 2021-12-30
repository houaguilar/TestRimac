//
//  SplashViewModel.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 22/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import RxSwift
import TraktKit

struct SplashViewModel {
    let sceneCoordinator: CoordinatorView
    init(coordinator:CoordinatorView) {
        self.sceneCoordinator = coordinator
    }
  
    func goToLogIn(){
        let logInViewModel = LoginViewModel(coordinator: sceneCoordinator)
        let loginScene = Scene.login(logInViewModel)
        sceneCoordinator.transition(to: loginScene, type: .push)
    }
}
