//
//  MoviesFetcher.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 30/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import RxSwift

struct MoviesFetcher {
    var networking: PopularMoviesAPI
    func getTwentyPopularMovies() -> Observable<SearchMoviesResponse> {

        return PopularMoviesAPI.shared.getTwentyPopularMovies()
    }
}
