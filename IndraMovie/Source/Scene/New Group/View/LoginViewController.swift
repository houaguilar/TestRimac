//
//  LoginViewController.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 29/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,
                            BindableType,
                            UIGestureRecognizerDelegate {
    var viewModel: LoginViewModel!
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGesture()
        setupUI()
    }
    // MARK: Setup UI
    func setupUI(){
        setupButton()
        setupUsernameField()
        setupPasswordField()
    }
    func setupButton(){
        button.isEnabled = false
        button.addTarget(self, action: #selector(loginProcess(_:)), for: .touchUpInside)
    }
    func setupPasswordField(){
        passwordField.isSecureTextEntry = true
        passwordField.placeholder = L10n.passwordField
        passwordField.keyboardType = .default
        passwordField.tag = 1
        passwordField.addTarget(self, action: #selector(changeText(textfield:)), for: .editingChanged)
    }
    func setupUsernameField(){
        usernameField.becomeFirstResponder()

        usernameField.clearButtonMode = .always
        usernameField.placeholder = L10n.usernameField
        usernameField.delegate = self
        usernameField.returnKeyType = .next
        usernameField.keyboardType = .emailAddress
        usernameField.tag = 0
    }
    func setupGesture(){
        let shortPressGesture = UITapGestureRecognizer(target: self, action: #selector(quitKeyboard(_:)))
        shortPressGesture.delegate = self
        self.view.addGestureRecognizer(shortPressGesture)
    }
    // MARK: Actions
    @objc func loginProcess(_ sender: UIButton){
        self.viewModel.goToHome()
    }
    @objc func changeText(textfield: UITextField) {
        if textfield.tag  == 1 && textfield.text!.isValidPassword {
            button.isEnabled = true
        }
    }
    @objc func quitKeyboard(_ gesture: UITapGestureRecognizer){
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    func bindViewModel() {
        
    }
}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !textField.text!.isEmpty && textField.text!.isValidUsername {
            usernameField.resignFirstResponder()
            passwordField.becomeFirstResponder()
        }
        return true
    }
}
