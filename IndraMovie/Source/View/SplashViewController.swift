//
//  SplashViewController.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 22/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import TraktKit
import SafariServices

class SplashViewController: UIViewController,BindableType {
    var viewModel: SplashViewModel!
    @IBOutlet weak var btnSignIn: UIButton!
    let disposeBag:DisposeBag = DisposeBag()
    func bindViewModel() {
        self.btnSignIn.rx.tap.bind {
                self.presentLogIn()
            }.disposed(by: disposeBag)
        if TraktManager.sharedManager.isSignedIn {
            self.btnSignIn.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.presentHome()
            }
        }
    }
    typealias ViewModelType = SplashViewModel
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(forName: .TraktSignedIn, object: nil, queue: nil) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil) // Dismiss the SFSafariViewController
            self?.viewModel.goToHome()
        }
    }
    // MARK: - Actions
    private func presentLogIn() {
        guard let oauthURL = TraktManager.sharedManager.oauthURL else { return }
        
        let traktAuth = SFSafariViewController(url: oauthURL)
        present(traktAuth, animated: true, completion: nil)
    }
    private func presentHome() {
          self.viewModel.goToHome()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
