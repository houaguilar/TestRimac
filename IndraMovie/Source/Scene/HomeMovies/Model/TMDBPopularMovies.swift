//
//  TMDBPopularMovies.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 27/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct TMDBPopularMovies: Codable {
    let dates: Dates
    let page: Int
    let results: [PopularMovies]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Dates
struct Dates: Codable {
    let maximum, minimum: String
}

// MARK: - Result
struct PopularMovies: Codable {
    let backdropPath: String?
    let id: Int
    let originalTitle, overview: String
    let posterPath:String?
    let releaseDate, title: String
  

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
    }
}

enum OriginalLanguage: String, Codable {
    case en = "en"
    case es = "es"
    case fr = "fr"
}
