//
//  PopularMoviesAPI.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 27/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import TraktKit
import RxCocoa
import RxSwift
import Alamofire
typealias SearchMoviesResponse = Result<([WrapperMovie]), MoviesServiceError>
public class PopularMoviesAPI {

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
    func urlSession() -> Observable<SearchMoviesResponse> {
        let observable = Observable<SearchMoviesResponse>.create { observer in
        let semaphore = DispatchSemaphore (value: 0)
        let url = URL(string: "https://dev.api.themoviedb.org/3/movie/upcoming?page=\(self.paginationTrending.page)&api_key=f46b58478f489737ad5a4651a4b25079")!
        var request = URLRequest(url: url,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                semaphore.signal()//GREEN
                return
            }
           
            do {
                let decoder = JSONDecoder()
                let tmdbData = try decoder.decode(TMDBPopularMovies.self, from: data)
                let wrapperMovies = tmdbData.results.map{$0.convertToWrapper()}
                let posters = tmdbData.results.map{$0.posterPath}
                for path in posters {
                    print(path)
                }
                semaphore.signal()//GREEN
                DispatchQueue.main.async {
                    observer.onNext(.success(wrapperMovies))
                    observer.onCompleted()
                    let currentPage = self.paginationTrending.page
                    self.paginationTrending = Pagination.init(page: self.paginationTrending.page + currentPage, limit: 20)
                }
               
            } catch let err {
                print(err)
            }
        }
        task.resume()
        semaphore.wait()//RED
            return Disposables.create()
        }
        return observable.retryOnBecomesReachable(.failure(.offline), reachabilityService: _reachabilityService)
    }
}

  //Serializer, Observer onext onError oncompleted, Subscriber ((ios 9)RxSwift, (ios 12)Combine, PromiseKit)

  
//            TraktManager.sharedManager.getPopularMovies(pagination: TrackMoviesAPI.sharedAPI.paginationTrending, extended: [.Full], filters: nil, completion: { result in
//
//                switch result {
//
//                case .error(let error):
//                    print("Failed to get search results: \(String(describing: error?.localizedDescription))")
//                    observer.onError(error!)
//                case .success(objects: let objects,
//                              currentPage: let currentPage,
//                              limit: let limit):
//                    var movies: [TraktMovie]!
//                    movies = objects
//                    let wrapperMovies = movies.map{$0.convertToWrapper()}
//                    observer.onNext(.success(wrapperMovies))
//                    observer.onCompleted()
//                    self.paginationTrending = Pagination.init(page: self.paginationTrending.page + currentPage, limit: limit)
//                }
//            })


