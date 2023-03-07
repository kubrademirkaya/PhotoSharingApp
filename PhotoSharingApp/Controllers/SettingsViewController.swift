//
//  SettingsViewController.swift
//  PhotoSharingApp
//
//  Created by Kübra Demirkaya on 11.12.2022.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let currentUserEmail = Auth.auth().currentUser?.email
        let currentUserCreatedDateTimestamp = Auth.auth().currentUser?.metadata.creationDate
        var currentUserCreatedDate: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM yyyy HH:mm"
            return formatter.string(from: currentUserCreatedDateTimestamp!)
        }
        
        createdDateLabel.text = currentUserCreatedDate
        userEmailLabel.text = currentUserEmail
        
    }
        
        
    @IBAction func logoutButtonClicked(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toViewController", sender: nil)
        } catch {
            
        }
        
    }
    
}
