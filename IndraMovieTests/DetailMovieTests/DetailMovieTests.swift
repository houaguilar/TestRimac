//
//  DetailMovieTests.swift
//  IndraMovieTests
//
//  Created by Jordy Aguilar on 22/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import Quick
import Nimble
import RxSwift
@testable import IndraMovie

class DetailMovieTests: QuickSpec {
    override func spec() {
        it("return detail movies"){
            var wrapperDetailMovie: WrapperDetailMovie!
            let fetcher = StubDetailMovieAPI()
            let disposeBag = DisposeBag()
            fetcher.getDetailMovie("674164").subscribe(onNext: { event in
                switch event {
                case .success(let detailMovie):
                    wrapperDetailMovie = detailMovie
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }).disposed(by: disposeBag)
            expect(wrapperDetailMovie).toEventuallyNot(beNil())
        }
        it("fills detailMovie data") {
            var wrapperDetailMovie: WrapperDetailMovie!
            let fetcher = StubDetailMovieAPI()
            let disposeBag = DisposeBag()
            fetcher.getDetailMovie("674164").subscribe(onNext: { event in
                switch event {
                case .success(let detailMovie):
                    wrapperDetailMovie = detailMovie
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }).disposed(by: disposeBag)
            expect(wrapperDetailMovie?.title).toEventually(equal("Return of Chucky"))
            expect(wrapperDetailMovie?.releaseDate).toEventually(equal("2021-12-31"))
        }
    }
}
