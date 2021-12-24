//
//  HomeViewModel.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 22/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import RxSwift
import TraktKit
struct HomeViewModel {
    let sceneCoordinator: CoordinatorView
    init(coordinator:CoordinatorView) {
        self.sceneCoordinator = coordinator
    }
    func getMovies(_ query:String)->Observable<SearchMoviesResponse>{
        return TrackMoviesAPI.sharedAPI.searchMovies(query: query)
    }
}
