//
//  MeliRequestInterceptor.swift
//
//  Created by Jordy Aguilar on 28/12/21.
//

import Foundation
import Alamofire

class MoviesRequestInterceptor: RequestInterceptor {
    let retryLimit = 3
    let retryDelay: TimeInterval = 10
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {
        let urlRequest = urlRequest
        completion(.success(urlRequest))
    }
}
