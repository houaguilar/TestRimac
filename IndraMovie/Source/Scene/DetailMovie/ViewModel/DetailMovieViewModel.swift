//
//  DetailMovieViewModel.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 29/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import Foundation
import RxSwift
struct DetailMovieViewModel {
    let sceneCoordinator: CoordinatorView
    let tmdbID: String
    init(coordinator: CoordinatorView, _ tmdbID: String) {
        self.sceneCoordinator = coordinator
        self.tmdbID = tmdbID
    }
    func getDetail() -> Observable<DetailMoviesResponse>{
        return DetailMovieApi.shared.getDetailMovie(self.tmdbID)
    }
    func goToBack(){
        sceneCoordinator.pop(animated: true)
    }
}
