//
//  SearchMoviesState.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 22/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import TraktKit
import RxSwift
import Foundation

enum MoviesCommand {
    case changeSearch(text: String)
    case loadMoreItems
    case moviesResponseReceived(SearchMoviesResponse)
}

struct SearchMoviesState {
    // control
    var searchText: String
    var shouldLoadNextPage: Bool
    var movies: Version<[WrapperMovie]> // Version is an optimization. When something unrelated changes, we don't want to reload table view.
    var failure: MoviesServiceError?
    
    init(searchText: String) {
        self.searchText = searchText
        shouldLoadNextPage = true
        movies = Version([])
        failure = nil
    }
}

extension SearchMoviesState {
    static let initial = SearchMoviesState(searchText: "")
    
    static func reduce(state: SearchMoviesState, command: MoviesCommand) -> SearchMoviesState {
        switch command {
        case .changeSearch(let text):
            return SearchMoviesState(searchText: text).mutateOne { $0.failure = state.failure }
        case .moviesResponseReceived(let result):
            switch result {
            case let .success((movies)):
                return state.mutate {
                    $0.movies = Version($0.movies.value + movies)
                    $0.shouldLoadNextPage = false
                    $0.failure = nil
                }
            case let .failure(error):
                return state.mutateOne { $0.failure = error }
            }
        case .loadMoreItems:
            return state.mutate {
                if $0.failure == nil {
                    $0.shouldLoadNextPage = true
                }
            }
        }
    }
}

import RxSwift
import RxCocoa

struct GithubQuery: Equatable {
    let searchText: String;
    let shouldLoadNextPage: Bool;
}

/**
 This method contains the gist of paginated IndraMovie search.
 
 */
func searchMovies(
    searchText: Signal<String>,
    loadNextPageTrigger: @escaping (Driver<SearchMoviesState>) -> Signal<()>,
    performSearch: @escaping (String) -> Observable<SearchMoviesResponse>
    ) -> Driver<SearchMoviesState> {
    
    
    
    let searchPerformerFeedback: (Driver<SearchMoviesState>) -> Signal<MoviesCommand> = react(
        query: { (state) in
            GithubQuery(searchText: state.searchText, shouldLoadNextPage: state.shouldLoadNextPage)
    },
        effects: { query -> Signal<MoviesCommand> in
            if !query.shouldLoadNextPage {
                return Signal.empty()
            }
            
            if query.searchText.isEmpty {
                return performSearch(query.searchText)
                    .asSignal(onErrorJustReturn: .failure(.networkError))
                    .map(MoviesCommand.moviesResponseReceived)

            }
            
            return performSearch(query.searchText)
                .asSignal(onErrorJustReturn: .failure(.networkError))
                .map(MoviesCommand.moviesResponseReceived)
    }

    )
    
    // this is degenerated feedback loop that doesn't depend on output state
    let inputFeedbackLoop: (Driver<SearchMoviesState>) -> Signal<MoviesCommand> = { state in
        let loadNextPage = loadNextPageTrigger(state).map { _ in MoviesCommand.loadMoreItems }
        let searchText = searchText.map(MoviesCommand.changeSearch)
        
        return Signal.merge(loadNextPage, searchText)
    }
    
    // Create a system with two feedback loops that drive the system
    // * one that tries to load new pages when necessary
    // * one that sends commands from user input
    return Driver.system(
        initialState: SearchMoviesState.initial,
        reduce: SearchMoviesState.reduce,
        feedback: searchPerformerFeedback, inputFeedbackLoop
    )
}

extension SearchMoviesState {
    var isOffline: Bool {
        guard let failure = self.failure else {
            return false
        }
        
        if case .offline = failure {
            return true
        }
        else {
            return false
        }
    }
    
    var isLimitExceeded: Bool {
        guard let failure = self.failure else {
            return false
        }
        
        if case .moviesLimitReached = failure {
            return true
        }
        else {
            return false
        }
    }
}

extension SearchMoviesState: Mutable {
    
}


