//
//  PaginatorMoviesAPI.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 27/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import UIKit
import RxSwift
import TraktKit

class PaginatorMoviesAPI: NSObject {
    fileprivate let _reachabilityService: ReachabilityService
    init(reachabilityService: ReachabilityService) {
        _reachabilityService = reachabilityService
    }
    func searchMovies(_ query:String) -> Observable<SearchMoviesResponse> {
        let limitPaginator = 20

        TrackMoviesAPI.sharedAPI.paginationTrending = Pagination.init(page:1, limit: limitPaginator)
        let observable = Observable<SearchMoviesResponse>.create { observer in
            
            TraktManager.sharedManager.search(query: query, types: [.movie], extended: [.Full], pagination: TrackMoviesAPI.sharedAPI.paginationSearch, filters: nil, fields: nil) { result in
                switch result {
                case .success(let objects):
                    var movies: [TraktMovie]!
                    movies = objects.compactMap { $0.movie }
                    let wrapperMovies = movies.map{$0.convertToWrapper()}
                    observer.onNext(.success(wrapperMovies))
                case .error(let error):
                    print("Failed to get search results: \(String(describing: error?.localizedDescription))")
                }
            }
            
            return Disposables.create()
        }
        return observable.retryOnBecomesReachable(.failure(.offline), reachabilityService: _reachabilityService)
    }
}
