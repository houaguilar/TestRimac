//
//  IndraMovieTests.swift
//  IndraMovieTests
//
//  Created by Jordy Aguilar on 22/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import Quick
import Nimble
import RxSwift
@testable import IndraMovie

class PopularMovieTests: QuickSpec {

    override func spec() {
        it("return popular movies"){
            var wrapperMovies: [WrapperMovie]!
            let fetcher = StubPopularMoviesAPI()
            let disposeBag = DisposeBag()
            fetcher.getTwentyPopularMovies().subscribe(onNext: { event in
                switch event {
                case .success(let popularMovies):
                    wrapperMovies = popularMovies
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }).disposed(by: disposeBag)
            expect(wrapperMovies).toEventuallyNot(beNil())
            expect(wrapperMovies?.count).toEventually(beGreaterThan(0))
        }
        it("fills movies data") {
            var wrapperMovies: [WrapperMovie]!
            let fetcher = StubPopularMoviesAPI()
            let disposeBag = DisposeBag()
            fetcher.getTwentyPopularMovies().subscribe(onNext: { event in
                switch event {
                case .success(let popularMovies):
                    wrapperMovies = popularMovies
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }).disposed(by: disposeBag)
            expect(wrapperMovies?[0].tmdb).toEventually(equal("634649"))
                       expect(wrapperMovies?[0].title).toEventually(equal("Spider-Man: No Way Home"))
                       expect(wrapperMovies?[0].year).toEventually(equal("2021-12-15"))
                       expect(wrapperMovies?[1].tmdb).toEventually(equal("568124"))
                       expect(wrapperMovies?[1].title).toEventually(equal("Encanto"))
                       expect(wrapperMovies?[1].year).toEventually(equal("2021-11-24"))
        }
    }

}
