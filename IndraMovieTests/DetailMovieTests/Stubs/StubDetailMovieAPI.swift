//
//  StubPopularMoviesAPI.swift
//  IndraMovieTests
//
//  Created by Jordy Aguilar on 22/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import RxSwift
@testable import IndraMovie

class StubDetailMovieAPI: DetailMovieApiProtocol {
    func getDetailMovie(_ tmdbID: String) -> Observable<DetailMoviesResponse> {

        return Observable<DetailMoviesResponse>.create { observer in
            guard let url = Bundle(for: StubPopularMoviesAPI.self)
                    .url(forResource: "detail-success-response", withExtension: "json"),
                  let data = try? Data(contentsOf: url)
            else {
                return Disposables.create()
            }
            guard let tmdbIMovieDetail = try? JSONDecoder().decode(TMDBIMovieDetail.self, from: data)
            else {
                return Disposables.create()
            }
            let wrapperDetailMovie = tmdbIMovieDetail.converToWrapperDetailMovie()
            observer.onNext(.success(wrapperDetailMovie))
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
