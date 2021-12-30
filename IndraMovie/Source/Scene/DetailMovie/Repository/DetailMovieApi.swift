//
//  DetailMovieApi.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 29/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import TraktKit
import RxCocoa
import RxSwift
import Alamofire
typealias DetailMoviesResponse = Result<(WrapperDetailMovie), MoviesServiceError>
public class DetailMovieApi {

    static var shared: DetailMovieApi = DetailMovieApi(reachabilityService: try! DefaultReachabilityService())
    fileprivate let _reachabilityService: ReachabilityService
    init(reachabilityService: ReachabilityService) {
        _reachabilityService = reachabilityService
    }
    func getDetailMovie(_ tmdbID:String) -> Observable<DetailMoviesResponse> {

        let observable = Observable<DetailMoviesResponse>.create { observer in
            
            let session = MoviesApiManager.shared.sessionManager
            let url = URL(string: "https://api.themoviedb.org/3/movie/\(tmdbID)")!

            let paramaters = ["api_key":"f46b58478f489737ad5a4651a4b25079"]
            session.request(url,
                            method: .get,
                            parameters: paramaters,
                            encoding: URLEncoding.queryString)
                .responseDecodable(of: TMDBIMovieDetail.self,
                                   queue: DispatchQueue.main,
                                   completionHandler: { dataResponse in
                    if let error = dataResponse.error {
                        print(error.errorDescription)
                    }
                    guard let tmdbIMovieDetail = dataResponse.value else {
                        return
                    }
//                    tmdbIMovieDetail.title
                    observer.onNext(.success(tmdbIMovieDetail.converToWrapperDetailMovie()))
                    observer.onCompleted()
                })
            return Disposables.create()
        }
        return observable.retryOnBecomesReachable(.failure(.offline), reachabilityService: _reachabilityService)
    }
}
