//
//  TMDBIMovieDetailModifier.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 30/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import UIKit

extension TMDBIMovieDetail {
    func converToWrapperDetailMovie() -> WrapperDetailMovie {
        let wrapperDetailMovie = WrapperDetailMovie()
        wrapperDetailMovie.title = self.originalTitle
        wrapperDetailMovie.releaseDate = self.releaseDate
        wrapperDetailMovie.overView = self.overview
        guard let pathUrl = URL(string: "https://image.tmdb.org/t/p/w500\(self.backdropPath)") else {
            return wrapperDetailMovie
        }
        wrapperDetailMovie.backPosterUrl = pathUrl
        guard let pathPosterUrl = URL(string: "https://image.tmdb.org/t/p/w500\(self.posterPath)") else {
            return wrapperDetailMovie
        }
        wrapperDetailMovie.posterUrl = pathPosterUrl
        return wrapperDetailMovie
    }
}
