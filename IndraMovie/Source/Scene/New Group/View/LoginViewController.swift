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
        button.isEnabled = false
        button.addTarget(self, action: #selector(loginProcess(_:)), for: .touchUpInside)
        usernameField.becomeFirstResponder()

        usernameField.clearButtonMode = .always
        usernameField.placeholder = L10n.usernameField//NSLocalizedString("usernameField", comment: "")
        usernameField.delegate = self
        usernameField.returnKeyType = .next
        usernameField.keyboardType = .emailAddress
        usernameField.tag = 0
        
        passwordField.isSecureTextEntry = true
        passwordField.placeholder = L10n.passwordField//NSLocalizedString("passwordField", comment: "")
        passwordField.keyboardType = .default
        passwordField.tag = 1
        
        passwordField.addTarget(self, action: #selector(changeText(textfield:)), for: .editingChanged)
        setupGesture()
    }
  
    func setupGesture(){
        let shortPressGesture = UITapGestureRecognizer(target: self, action: #selector(quitKeyboard(_:)))
        shortPressGesture.delegate = self
        self.view.addGestureRecognizer(shortPressGesture)
    }
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
extension String {
    var isValidUsername: Bool {
        let emailRegEx = "^[a-zA-Z\\_]{4,18}$"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    var isValidPassword: Bool {
        let emailRegEx = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}
