//
//  MoviesRepositories.swift
//  TrackTV
//
//  Created by Raul on 7/12/19.
//  Copyright © 2019 Raul Quispe. All rights reserved.
//

import UIKit
import TraktKit
import RxSwift
import RxCocoa
import RxDataSources

struct MoviesRepositories {
  
}
enum MoviesCommand {
    case changeSearch(text: String)
    case loadMoreItems
//    case gitHubResponseReceived(SearchRepositoriesResponse)
}
struct MoviesSearchRepositoriesState {
    // control
    var searchText: String
    var shouldLoadNextPage: Bool
    var repositories: Version<[TraktMovie]>
  //  var nextURL: URL?
    var failure: MoviesServiceError?
    
    init(searchText: String) {
        self.searchText = searchText
        shouldLoadNextPage = true
        repositories = Version([])
     //   nextURL = URL(string: "https://api.github.com/search/repositories?q=\(searchText.URLEscaped)")
        failure = nil
    }
}
extension MoviesSearchRepositoriesState {
    static let initial = MoviesSearchRepositoriesState(searchText: "")
    
    static func reduce(state: MoviesSearchRepositoriesState, command: MoviesCommand) -> MoviesSearchRepositoriesState {
        switch command {
        case .changeSearch(let text):
            return MoviesSearchRepositoriesState(searchText: text).mutateOne { $0.failure = state.failure }
        case .gitHubResponseReceived(let result):
            switch result {
            case let .success((repositories, nextURL)):
                return state.mutate {
                    $0.repositories = Version($0.repositories.value + repositories)
                    $0.shouldLoadNextPage = false
                    $0.nextURL = nextURL
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
func trakSearchMovies(
    searchText: Signal<String>,
    loadNextPageTrigger: @escaping (Driver<MoviesSearchRepositoriesState>) -> Signal<()>,
    performSearch: @escaping (URL) -> Observable<SearchRepositoriesResponse>
    ) -> Driver<MoviesSearchRepositoriesState> {
    
    
    
    let searchPerformerFeedback: (Driver<MoviesSearchRepositoriesState>) -> Signal<MoviesCommand> = react(
        query: { (state) in
            GithubQuery(searchText: state.searchText, shouldLoadNextPage: state.shouldLoadNextPage, nextURL: state.nextURL)
    },
        effects: { query -> Signal<MoviesCommand> in
            if !query.shouldLoadNextPage {
                return Signal.empty()
            }
            
            if query.searchText.isEmpty {
                return Signal.just(GitHubCommand.gitHubResponseReceived(.success((repositories: [], nextURL: nil))))
            }
            
            guard let nextURL = query.nextURL else {
                return Signal.empty()
            }
            
            return performSearch(nextURL)
                .asSignal(onErrorJustReturn: .failure(GitHubServiceError.networkError))
                .map(GitHubCommand.gitHubResponseReceived)
    }
    )
    
    // this is degenerated feedback loop that doesn't depend on output state
    let inputFeedbackLoop: (Driver<MoviesSearchRepositoriesState>) -> Signal<MoviesCommand> = { state in
        let loadNextPage = loadNextPageTrigger(state).map { _ in MoviesCommand.loadMoreItems }
        let searchText = searchText.map(MoviesCommand.changeSearch)
        
        return Signal.merge(loadNextPage, searchText)
    }
    
    // Create a system with two feedback loops that drive the system
    // * one that tries to load new pages when necessary
    // * one that sends commands from user input
    return Driver.system(
        initialState: MoviesSearchRepositoriesState.initial,
        reduce: MoviesSearchRepositoriesState.reduce,
        feedback: searchPerformerFeedback, inputFeedbackLoop
    )
}

extension MoviesSearchRepositoriesState {
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
extension SharedSequenceConvertibleType where Element == Any, SharingStrategy == DriverSharingStrategy {
    /// Feedback loop
    public typealias Feedback<State, Event> = (Driver<State>) -> Signal<Event>
    
    /**
     System simulation will be started upon subscription and stopped after subscription is disposed.
     
     System state is represented as a `State` parameter.
     Events are represented by `Event` parameter.
     
     - parameter initialState: Initial state of the system.
     - parameter accumulator: Calculates new system state from existing state and a transition event (system integrator, reducer).
     - parameter feedback: Feedback loops that produce events depending on current system state.
     - returns: Current state of the system.
     */
    public static func system<State, Event>(
        initialState: State,
        reduce: @escaping (State, Event) -> State,
        feedback: [Feedback<State, Event>]
        ) -> Driver<State> {
        let observableFeedbacks: [(ObservableSchedulerContext<State>) -> Observable<Event>] = feedback.map { feedback in
            return { sharedSequence in
                return feedback(sharedSequence.source.asDriver(onErrorDriveWith: Driver<State>.empty()))
                    .asObservable()
            }
        }
        
        return Observable<Any>.system(
            initialState: initialState,
            reduce: reduce,
            scheduler: SharingStrategy.scheduler,
            scheduledFeedback: observableFeedbacks
            )
            .asDriver(onErrorDriveWith: .empty())
    }
    
    public static func system<State, Event>(
        initialState: State,
        reduce: @escaping (State, Event) -> State,
        feedback: Feedback<State, Event>...
        ) -> Driver<State> {
        return system(initialState: initialState, reduce: reduce, feedback: feedback)
    }
}
