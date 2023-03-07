//
//  ForgotPasswordViewController.swift
//  PhotoSharingApp
//
//  Created by Kübra Demirkaya on 7.03.2023.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func sendButtonClicked(_ sender: Any) {
        
        let auth = Auth.auth()
        
        auth.sendPasswordReset(withEmail: userEmailTextField.text!) { error in
            if error != nil {
                
                self.alert(titleInput: "Error", messageInput: error!.localizedDescription)
                
            } else {
                
                let alert = UIAlertController(title: "Successfully", message: "Password reset email has been sent.", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
                    self.navigationController?.popToRootViewController(animated: true)
                }
                alert.addAction(okButton)
                self.present(alert, animated: true)
                
            }
        }
        
    }
    
    func alert (titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
}
