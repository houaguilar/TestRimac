//
//  MeliApiManager.swift
//
//  Created by Jordy Aguilar on 28/12/21.
//

import Foundation
import Alamofire

class MoviesApiManager: NSObject {
    static let shared = MoviesApiManager()
    let sessionManager: Session = {
            let configuration = URLSessionConfiguration.af.default
            configuration.requestCachePolicy = .returnCacheDataElseLoad
            let responseCacher = ResponseCacher(behavior: .modify { _, response in
                let userInfo = ["date": Date()]
                return CachedURLResponse(
                    response: response.response,
                    data: response.data,
                    userInfo: userInfo,
                    storagePolicy: .allowed)
            })
            
            let networkLogger = MoviesNetworkLogger()
            let interceptor = MoviesRequestInterceptor()
            
            return Session(configuration: configuration,
                           interceptor: interceptor,
                           cachedResponseHandler: responseCacher,
                           eventMonitors: [networkLogger])
        }()
}
