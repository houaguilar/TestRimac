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
        usernameField.placeholder = "Ingresa Email"
        usernameField.delegate = self
        usernameField.returnKeyType = .next
        usernameField.keyboardType = .emailAddress
        usernameField.tag = 0
        
        passwordField.isSecureTextEntry = true
        passwordField.placeholder = "Contraseña"
        passwordField.keyboardType = .numberPad
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
        print("ya me tengo que ir a cenar")
        self.viewModel.goToHome()
    }
    @objc func changeText(textfield: UITextField) {
        if textfield.tag  == 1 && textfield.text?.count == 3 {
            passwordField.resignFirstResponder()
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
        if !textField.text!.isEmpty && textField.text!.isValidEmail {
            usernameField.resignFirstResponder()
            passwordField.becomeFirstResponder()
        }
        return true
    }
}
extension String {
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}
