//
//  TraktMoviesAPI.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 22/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import TraktKit
import RxCocoa
import RxSwift

enum MoviesServiceError: Error {
    case offline
    case moviesLimitReached
    case networkError
}

typealias SearchMoviesResponse = Result<([WrapperMovie]), MoviesServiceError>
class TrackMoviesAPI {
    
    static let sharedAPI = TrackMoviesAPI(reachabilityService: try! DefaultReachabilityService())

    var paginationSearch:Pagination = Pagination.init(page: 1, limit: 20)
    var paginationTrending:Pagination = Pagination.init(page: 1, limit: 20)
    fileprivate let _reachabilityService: ReachabilityService
    private struct ConstantsApiOMDB {
        static let urlBase = "http://www.omdbapi.com"
        static let apikey = "2a08d4ad"
    }
    private init(reachabilityService: ReachabilityService) {
        _reachabilityService = reachabilityService
    }
}

extension TrackMoviesAPI {
    public func getTenPopularMovies() -> Observable<SearchMoviesResponse> {
        let observable = Observable<SearchMoviesResponse>.create { observer in

            TraktManager.sharedManager.getPopularMovies(pagination: TrackMoviesAPI.sharedAPI.paginationTrending, extended: [.Full], filters: nil, completion: { result in

                switch result {
                case .success(let completionObject):
                    var movies: [TraktMovie]!
                    movies = completionObject.objects

                    self.getObjectsMovies(movies: movies,completionMovie: {(moviews) in
                        DispatchQueue.main.async{
                            observer.onNext(.success(moviews))
                            observer.onCompleted()
                            TrackMoviesAPI.sharedAPI.paginationTrending = Pagination.init(page: TrackMoviesAPI.sharedAPI.paginationTrending.page + 1, limit: 20)
                        }
                      
                    })
 
                case .error(let error):
                    print("Failed to get search results: \(String(describing: error?.localizedDescription))")
                    observer.onError(error!)
                }
            })
            return Disposables.create()
        }
        return observable.retryOnBecomesReachable(.failure(.offline), reachabilityService: _reachabilityService)
    }
    public func getObjectsMovies(movies:[TraktMovie],completionMovie: @escaping ([WrapperMovie]) -> Void){
       

            var wMovies = [WrapperMovie]()
            for itemMovie in movies {
                let newMovie = WrapperMovie()
                newMovie.title = itemMovie.title
                
                if itemMovie.ids.imdb != nil {
                    newMovie.imdb = itemMovie.ids.imdb
                }else{
                    newMovie.imdb = ""
                }
                if itemMovie.year != nil {
                 newMovie.year = String(itemMovie.year!)
                }else{
                    newMovie.year = "-"
                }
                if itemMovie.overview != nil {
                 newMovie.overView = itemMovie.overview
                } else {
                 newMovie.overView = "-"
                }
                if newMovie.url == nil && newMovie.imdb != nil {
                    TrackMoviesAPI.sharedAPI.getUrlFromID(imdb: newMovie.imdb! , completion: {(data,error) in
                        newMovie.url = data

                        wMovies.append(newMovie)
                        if wMovies.count == 20 {
                            completionMovie(wMovies)
                        }
                    })
                }
                
            }
    }
    public func searchMovies(query:String) -> Observable<SearchMoviesResponse> {
        let limitPaginator = 20
        if query.isEmpty {
            TrackMoviesAPI.sharedAPI.paginationSearch = Pagination.init(page: 1, limit: limitPaginator)
            return getTenPopularMovies()
        }else{
             TrackMoviesAPI.sharedAPI.paginationTrending = Pagination.init(page:1, limit: limitPaginator)
            let observable = Observable<SearchMoviesResponse>.create { observer in
               
                TraktManager.sharedManager.search(query: query, types: [.movie], extended: [.Full], pagination: TrackMoviesAPI.sharedAPI.paginationSearch, filters: nil, fields: nil) { result in
                    switch result {
                    case .success(let objects):
                        var movies: [TraktMovie]!
                        movies = objects.compactMap { $0.movie }
                        self.getObjectsMovies(movies: movies,completionMovie: {(moviews) in
                            DispatchQueue.main.async{
                                observer.onNext(.success(moviews))
                                observer.onCompleted()
                                TrackMoviesAPI.sharedAPI.paginationTrending = Pagination.init(page: TrackMoviesAPI.sharedAPI.paginationTrending.page + 1, limit: limitPaginator)
                            }
                            
                        })
                    case .error(let error):
                        print("Failed to get search results: \(String(describing: error?.localizedDescription))")
                    }
                }
                
                return Disposables.create()
            }
            return observable.retryOnBecomesReachable(.failure(.offline), reachabilityService: _reachabilityService)
        }
    }

    func getUrlFromID(imdb:String,completion: @escaping (URL?, Error?) -> Void)  {
        let url = URL(string: ConstantsApiOMDB.urlBase + "/?i=" + imdb + "&apikey=" + ConstantsApiOMDB.apikey)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let session:URLSession
        session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request, completionHandler: { data,response,error in
            guard let data = data else { return }
            
            if let error = error {
                print(error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let imdbData = try decoder.decode(ImdbData.self, from: data)
                if imdbData.Poster == nil {
                     completion(nil, nil)
                }else{
                     completion(URL(string: imdbData.Poster!)!, nil)
                }
               
            } catch let err {
                print(err)
            }
        })
        task.resume()
    }

}
struct ImdbData: Decodable {
    let Poster: String?

}
