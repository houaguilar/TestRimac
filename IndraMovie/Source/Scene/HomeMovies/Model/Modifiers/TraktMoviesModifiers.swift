//
//  TraktMoviesModifiers.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 27/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import UIKit
import TraktKit

extension TraktMovie {
    func convertToWrapper()->WrapperMovie{
        let wrapperMovie = WrapperMovie()
        wrapperMovie.title = self.title
        if let tmdb = self.ids.imdb {
            wrapperMovie.tmdb = "\(String(describing: tmdb))"
        }else{
            wrapperMovie.tmdb = ""
        }
        if self.year != nil {
            wrapperMovie.year = String(self.year!)
        }else{
            wrapperMovie.year = "-"
        }
        if self.overview != nil {
            wrapperMovie.overView = self.overview
        } else {
            wrapperMovie.overView = "-"
        }
        wrapperMovie.url = URL(string: "https://image.tmdb.org/t/p/w500/8UlWHLMpgZm9bx6QYh0NFoq67TZ.jpg")!
        return wrapperMovie
    }
}
