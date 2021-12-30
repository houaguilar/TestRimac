//
//  PaginatorMoviesAPI.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 27/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire

class PaginatorMoviesAPI: NSObject {
    fileprivate let _reachabilityService: ReachabilityService
    var paginationSearch:Pagination = Pagination.init(page: 1, limit: 20)
    init(reachabilityService: ReachabilityService) {
        _reachabilityService = reachabilityService
    }
    func searchMovies(_ query:String) -> Observable<SearchMoviesResponse> {
        let observable = Observable<SearchMoviesResponse>.create { observer in
            
            let session = MoviesApiManager.shared.sessionManager
            let url = URL(string: "https://api.themoviedb.org/3/search/movie")!
            let page = "\(self.paginationSearch.page)"
            let paramaters = ["page":page,
                              "api_key":"f46b58478f489737ad5a4651a4b25079",
                              "query":query]
            session.request(url,
                            method: .get,
                            parameters: paramaters,
                            encoding: URLEncoding.queryString)
                .responseDecodable(of: TMDBPopularMovies.self,
                                   queue: DispatchQueue.main,
                                   completionHandler: { dataResponse in
                    if let error = dataResponse.error {
                        print(error.errorDescription)
                    }
                    guard let tmdbPopularMovies = dataResponse.value else {
                        return
                    }
                    let wrapperMovies = tmdbPopularMovies.results.map{$0.convertToWrapper()}
                    observer.onNext(.success(wrapperMovies))
                    let currentPage = self.paginationSearch.page
                    self.paginationSearch = Pagination.init(page: self.paginationSearch.page + currentPage, limit: 20)
                    observer.onCompleted()
                })
            return Disposables.create()
        }
        return observable.retryOnBecomesReachable(.failure(.offline), reachabilityService: _reachabilityService)
    }
}
