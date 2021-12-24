//
//  Scene.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 22/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
extension Scene {
    static let mainStorybardName = "Main"
    static let searchStorybardName = "SearchMovies"
    static let splashView = "splashView"
    static let homeView = "homeView"
    func viewController() -> UIViewController {
        switch self {
        case .splash(let viewModel):
            let storyboard = UIStoryboard(name: Scene.mainStorybardName, bundle: nil)
            var view:SplashViewController = storyboard.instantiateViewController(withIdentifier: Scene.splashView) as! SplashViewController
            view.bindViewModel(to: viewModel)
            return view
        case .home(let viewModel):
            let storyboard = UIStoryboard(name: Scene.searchStorybardName, bundle: nil)
            var view:HomeViewController = storyboard.instantiateViewController(withIdentifier: Scene.homeView) as! HomeViewController
            view.bindViewModel(to: viewModel)
            return view
        }
    }
}

enum Scene {
    case splash(SplashViewModel)
    case home(HomeViewModel)
}

class SceneReactive: CoordinatorView {
    
    unowned let window:UIWindow
    private(set) var currentView:UIViewController!
    required init(window: UIWindow) {
        self.window = window
    }
    
    static func actualViewController(for viewController: UIViewController) -> UIViewController {
        if let navigationController = viewController as? UINavigationController {
            return navigationController.viewControllers.first!
        } else {
            return viewController
        }
    }
    
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Completable {
        let subject = PublishSubject<Void>()
        let viewController = scene.viewController()
        switch type {
        case .root:
            currentView = SceneReactive.actualViewController(for: viewController)
            let nav = UINavigationController(rootViewController: currentView)
            nav.isNavigationBarHidden = true
            window.rootViewController = nav
            subject.onCompleted()
            
        case .push:
            guard let navigationController = currentView.navigationController else {
                fatalError("Can't push a view controller without a current navigation controller")
            }
            // one-off subscription to be notified when push complete
            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
            navigationController.pushViewController(viewController, animated: true)
            currentView = SceneReactive.actualViewController(for: viewController)
            
        case .modal:
            currentView.present(viewController, animated: true) {
                subject.onCompleted()
            }
            currentView = SceneReactive.actualViewController(for: viewController)
        }
        return subject.asObservable()
            .take(1)
            .ignoreElements()
    }
    
    @discardableResult
    func pop(animated: Bool) -> Completable {
        let subject = PublishSubject<Void>()
        if let presenter = currentView.presentingViewController {
            // dismiss a modal controller
            currentView.dismiss(animated: animated) {
                self.currentView = SceneReactive.actualViewController(for: presenter)
                subject.onCompleted()
            }
        } else if let navigationController = currentView.navigationController {
            // navigate up the stack
            // one-off subscription to be notified when pop complete
            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
            guard navigationController.popViewController(animated: animated) != nil else {
                fatalError("can't navigate back from \(String(describing: currentView))")
            }
            currentView = SceneReactive.actualViewController(for: navigationController.viewControllers.last!)
        } else {
            fatalError("Not a modal, no navigation controller: can't navigate back from \(String(describing: currentView))")
        }
        return subject.asObservable()
            .take(1)
            .ignoreElements()
    }
}
