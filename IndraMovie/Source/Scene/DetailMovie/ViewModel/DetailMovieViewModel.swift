//
//  DetailMovieViewModel.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 29/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import Foundation

struct DetailMovieViewModel {
    let sceneCoordinator: CoordinatorView
    init(coordinator:CoordinatorView) {
        self.sceneCoordinator = coordinator
    }
    func goToBack(){
        sceneCoordinator.pop(animated: true)
    }
}
