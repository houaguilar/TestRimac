//
//  HomeViewModel.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 22/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import RxSwift
import TraktKit
protocol HomeViewModelDelegate: AnyObject {
    func goToBack()
}
struct HomeViewModel {
    var delegate: HomeViewModelDelegate?
    let sceneCoordinator: CoordinatorView
    init(coordinator:CoordinatorView) {
        self.sceneCoordinator = coordinator
    }
    func getMovies(_ query:String)->Observable<SearchMoviesResponse>{
        if query.isEmpty {
            return PopularMoviesAPI.shared.getTwentyPopularMovies()
        }else{
            return getMoviesFrom(query)
        }
    }
    private func getMoviesFrom(_ query:String)->Observable<SearchMoviesResponse>{
        return PaginatorMoviesAPI(reachabilityService: try! DefaultReachabilityService()).searchMovies(query)
    }
    func goToDetail(_ tmdbID: String){
        let detailMovieViewModel = DetailMovieViewModel(coordinator: sceneCoordinator,
                                                        tmdbID)
        let detailMovieScene = Scene.detail(detailMovieViewModel)
        sceneCoordinator.transition(to: detailMovieScene, type: .push)
    }
}
