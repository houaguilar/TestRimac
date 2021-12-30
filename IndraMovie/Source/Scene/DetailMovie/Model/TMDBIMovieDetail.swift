//
//  OMDBIMovie.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 22/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import Foundation

// MARK: - OMDBIMovie
struct TMDBIMovieDetail: Codable {

    let backdropPath: String
    let genres: [Genre]
    let id: Int
    let imdbID, originalLanguage, originalTitle, overview: String
    let posterPath: String
    let releaseDate: String
    let title: String

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genres, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"

        case releaseDate = "release_date"
        case title
    }
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int
    let name: String
}
