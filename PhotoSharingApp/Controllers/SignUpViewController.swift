//
//  SignUpViewController.swift
//  PhotoSharingApp
//
//  Created by Kübra Demirkaya on 2.03.2023.
//

import UIKit
import FirebaseAuth
import FirebaseCore


class SignUpViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var iconClick = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        
        if userEmailTextField.text != "" && passwordTextField.text != "" {
            
            Auth.auth().createUser(withEmail: userEmailTextField.text!, password: passwordTextField.text!) {
                
                (authdataresult, error) in
                if error != nil {
                    self.errorMessage(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error, try again")
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
            
        } else {
            errorMessage(titleInput: "Error", messageInput: "enter username and password")
        }
        
    }
    @IBAction func secureButtonClicked(_ sender: Any) {
        
        if iconClick {
                passwordTextField.isSecureTextEntry = false
            } else {
                passwordTextField.isSecureTextEntry = true
            }
            iconClick = !iconClick
    }
    
    
    
    func errorMessage (titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    

}
