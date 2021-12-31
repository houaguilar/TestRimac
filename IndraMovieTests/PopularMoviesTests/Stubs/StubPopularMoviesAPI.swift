//
//  StubPopularMoviesAPI.swift
//  IndraMovieTests
//
//  Created by Jordy Aguilar on 30/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//
import RxSwift
@testable import IndraMovie

class StubPopularMoviesAPI: PopularMoviesAPIProtocol {
    func getTwentyPopularMovies() -> Observable<SearchMoviesResponse> {
        return Observable<SearchMoviesResponse>.create { observer in
            guard let url = Bundle(for: StubPopularMoviesAPI.self)
                    .url(forResource: "popular-sucess-response", withExtension: "json"),
                  let data = try? Data(contentsOf: url)
            else {
                return Disposables.create()
            }
            
            guard let tmdbPopularMovies = try? JSONDecoder().decode(TMDBPopularMovies.self, from: data)
            else {
                return Disposables.create()
            }
            let wrapperMovies = tmdbPopularMovies.results.map{$0.convertToWrapper()}
            observer.onNext(.success(wrapperMovies))
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
