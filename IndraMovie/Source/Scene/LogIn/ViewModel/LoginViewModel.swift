//
//  LoginViewModel.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 29/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import Foundation

struct LoginViewModel {
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
