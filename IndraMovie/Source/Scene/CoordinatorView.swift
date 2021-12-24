//
//  CoordinatorView.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 22/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import UIKit
import RxSwift
enum SceneTransitionType {
    
    case root       // make view controller the root view controller
    case push       // push view controller to navigation stack
    case modal      // present view controller modally
}

protocol CoordinatorView {
    init(window:UIWindow)
    /// transition to another scene
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Completable
    
    /// pop scene from navigation stack or dismiss current modal
    @discardableResult
    func pop(animated: Bool) -> Completable
}

extension CoordinatorView {
    @discardableResult
    func pop() -> Completable {
        return pop(animated: true)
    }
}
