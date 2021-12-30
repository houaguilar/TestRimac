//
//  MoviesServiceError.swift
//  IndraMovie
//
//  Created by Raul on 30/12/21.
//  Copyright © 2021 Raul Quispe. All rights reserved.
//

import Foundation

enum MoviesServiceError: Error {
    case offline
    case moviesLimitReached
    case networkError
}
