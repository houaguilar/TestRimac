//
//  PopularMoviesModifiers.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 27/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import UIKit

extension PopularMovies {
    func convertToWrapper()-> WrapperMovie {
        let wrapperMovie = WrapperMovie()
        wrapperMovie.title = self.title
        wrapperMovie.tmdb = "\(String(describing: self.id))"
        wrapperMovie.year = self.releaseDate
        wrapperMovie.overView = self.overview
        guard let poster = self.posterPath else {
            return wrapperMovie
        }
        guard let pathUrl = URL(string: "https://image.tmdb.org/t/p/w500\(poster)") else {
            return wrapperMovie
        }
        wrapperMovie.url = pathUrl
        return wrapperMovie
    }
}
