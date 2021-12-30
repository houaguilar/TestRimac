//
//  HomeViewController.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 22/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import TraktKit
import RxDataSources

class HomeViewController: ViewController,BindableType, UITableViewDelegate {
    //MARK: Properties
    var viewModel: HomeViewModel!
    static let itemId = "Cell"
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    typealias ViewModelType = HomeViewModel
    
    func bindViewModel() {
        
    }
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, WrapperMovie>>(
        configureCell: { (_, tv, ip, movie: WrapperMovie) in
            let cell = tv.dequeueReusableCell(withIdentifier: HomeViewController.itemId) as! MovieTableViewCell
            cell.separatorInset = .zero
            cell.loadWithData(movie)
            return cell
        },
        titleForHeaderInSection: { dataSource, sectionIndex in
            let section = dataSource[sectionIndex]
            return section.items.count > 0 ? "Movies (\(section.items.count))" : "No Movies found retry"
        }
    )
    override func viewDidLoad() {
        super.viewDidLoad()
        setupListMovies()
        setupSearchBar()
    }
    func setupListMovies() {
        let tableView: UITableView = self.tableView
        tableView.separatorColor = .clear
        tableView.allowsSelection = false
        let loadNextPageTrigger: (Driver<SearchMoviesState>) -> Signal<()> =  { state in
            tableView.rx.contentOffset.asDriver()
                .withLatestFrom(state)
                .flatMap { state in
                    return tableView.isNearBottomEdge(edgeOffset: 20.0) && !state.shouldLoadNextPage
                    ? Signal.just(())
                    : Signal.empty()
                }
        }
        let activityIndicator = ActivityIndicator()
        let searchBar: UISearchBar = self.searchBar
        // We want the search bar visible all the time.
        let state = searchMovies(
            searchText: searchBar.rx.text.orEmpty.changed.asSignal().throttle(.milliseconds(300)),
            loadNextPageTrigger: loadNextPageTrigger,
            performSearch: { query in
                self.viewModel.getMovies(query)
                    .trackActivity(activityIndicator)
            })
        

        state
            .map { $0.movies }
            .distinctUntilChanged()
            .map { [SectionModel(model: "Movies", items: $0.value)] }
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        state
            .map { $0.isLimitExceeded }
            .distinctUntilChanged()
            .filter { $0 }
            .drive(onNext: { n in
                
            })
            .disposed(by: disposeBag)
        
        tableView.rx.contentOffset
            .subscribe { _ in
                if searchBar.isFirstResponder {
                    _ = searchBar.resignFirstResponder()
                }
            }
            .disposed(by: disposeBag)
        
        // so normal delegate customization can also be used
        self.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        // activity indicator in status bar
        // {
        activityIndicator
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)
        // }
    }
    func setupSearchBar(){
        let searchController = UISearchController(searchResultsController: nil)
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // Fallback on earlier versions
            tableView.tableHeaderView = searchController.searchBar
        }
    }
    // MARK: Table view delegate
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = .clear
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    deinit {
        // I know, I know, this isn't a good place of truth, but it's no
        self.navigationController?.navigationBar.backgroundColor = nil
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
extension UIScrollView {
    func  isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}
