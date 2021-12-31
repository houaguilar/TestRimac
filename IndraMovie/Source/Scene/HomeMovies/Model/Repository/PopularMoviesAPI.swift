//
//  PopularMoviesAPI.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 27/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import RxCocoa
import RxSwift
import Alamofire
typealias SearchMoviesResponse = Result<([WrapperMovie]), MoviesServiceError>
protocol PopularMoviesAPIProtocol {
    func getTwentyPopularMovies() -> Observable<SearchMoviesResponse>
}
public class PopularMoviesAPI: PopularMoviesAPIProtocol {

    static var shared: PopularMoviesAPI = PopularMoviesAPI(reachabilityService: try! DefaultReachabilityService())
    fileprivate let _reachabilityService: ReachabilityService
    var paginationTrending:Pagination = Pagination.init(page: 1, limit: 20)
    init(reachabilityService: ReachabilityService) {
        _reachabilityService = reachabilityService
    }
    func getTwentyPopularMovies() -> Observable<SearchMoviesResponse> {

        let observable = Observable<SearchMoviesResponse>.create { observer in
            
            let session = MoviesApiManager.shared.sessionManager
            let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming")!
            let page = "\(self.paginationTrending.page)"
            let paramaters = ["page":page,
                              "api_key":"f46b58478f489737ad5a4651a4b25079"]
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
                    let currentPage = self.paginationTrending.page
                    self.paginationTrending = Pagination.init(page: self.paginationTrending.page + currentPage, limit: 20)
                    observer.onCompleted()
                })
            return Disposables.create()
        }
        return observable.retryOnBecomesReachable(.failure(.offline), reachabilityService: _reachabilityService)
    }
}
