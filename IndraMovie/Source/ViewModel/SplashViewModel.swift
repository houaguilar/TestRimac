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
    func goToHome(){
        let homeViewModel = HomeViewModel(coordinator: sceneCoordinator)
        let homeScene = Scene.home(homeViewModel)
        sceneCoordinator.transition(to: homeScene, type: .push)
    }
}
