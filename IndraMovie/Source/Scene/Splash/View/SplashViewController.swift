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

class SplashViewController: UIViewController,BindableType {
    var viewModel: SplashViewModel!
    @IBOutlet weak var btnSignIn: UIButton!
    let disposeBag:DisposeBag = DisposeBag()
    func bindViewModel() {
        self.btnSignIn.rx.tap.bind {
                self.presentLogIn()
            }.disposed(by: disposeBag)
    }
    typealias ViewModelType = SplashViewModel
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Actions
    private func presentLogIn() {
        self.viewModel.goToLogIn()
    }
    private func presentHome() {
        self.viewModel.goToLogIn()
    }
  
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
