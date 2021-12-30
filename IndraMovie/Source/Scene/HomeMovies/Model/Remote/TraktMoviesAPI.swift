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


class TrackMoviesAPI {
    
    static let sharedAPI = TrackMoviesAPI(reachabilityService: try! DefaultReachabilityService())
    
    var paginationSearch:Pagination = Pagination.init(page: 1, limit: 20)
    var paginationTrending:Pagination = Pagination.init(page: 1, limit: 20)
    fileprivate let _reachabilityService: ReachabilityService
    private struct ConstantsApiOMDB {
        static let urlBase = "https://api.themoviedb.org/3"
        static let apikey = "76cd0e2ff5ba4d7b65649db017e29e86"
        static let urlImageBase = "https://image.tmdb.org/t/p/w500"
    }
    //    themoviedb
    private init(reachabilityService: ReachabilityService) {
        _reachabilityService = reachabilityService
    }
}

extension TrackMoviesAPI {
    
    public func getObjectsMovies(movies:[TraktMovie],completionMovie: @escaping ([WrapperMovie]) -> Void){
        var wMovies = [WrapperMovie]()
        for itemMovie in movies {
            let newMovie = WrapperMovie()
            newMovie.title = itemMovie.title
            if itemMovie.ids.imdb != nil {
                newMovie.tmdb = "\(String(describing: itemMovie.ids.tmdb!))"
            }else{
                newMovie.tmdb = ""
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
            if newMovie.url == nil && newMovie.tmdb != nil {
                TrackMoviesAPI.sharedAPI.getDetailFromID(tmdbID: newMovie.tmdb! , completion: {(tmdb,error) in
                    guard let tmdbData = tmdb else {
                        return
                    }
                    let urlPathString:String = tmdbData.posterPath
                    newMovie.url = URL(string: ConstantsApiOMDB.urlImageBase + urlPathString)!
                    wMovies.append(newMovie)
                    completionMovie(wMovies)
                   
                })
            }
        }
    }
    
    
    func getDetailFromID(tmdbID:String,completion: @escaping (TMDBIMovieDetail?, Error?) -> Void)  {
        let url = URL(string: ConstantsApiOMDB.urlBase + "/movie/" + tmdbID + "?api_key=" + ConstantsApiOMDB.apikey)!
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
                let tmdbData = try decoder.decode(TMDBIMovieDetail.self, from: data)
                completion(tmdbData, nil)
            } catch let err {
                print(err)
            }
        })
        task.resume()
    }
    
}
