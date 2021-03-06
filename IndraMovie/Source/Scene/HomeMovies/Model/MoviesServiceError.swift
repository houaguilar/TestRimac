//
//  MoviesServiceError.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 30/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import Foundation

enum MoviesServiceError: Error {
    case offline
    case moviesLimitReached
    case networkError
}
