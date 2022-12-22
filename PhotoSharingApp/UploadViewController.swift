//
//  UploadViewController.swift
//  PhotoSharingApp
//
//  Created by Kübra Demirkaya on 11.12.2022.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    
    var isWorking = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        saveButton.isEnabled = false
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        activityIndicator.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        saveButton.isEnabled = false
    }
    
    @objc func chooseImage() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
            imageView.image = info[.originalImage] as? UIImage
            self.dismiss(animated: true)
            saveButton.isEnabled = true
       
    }

    @IBAction func uploadButtonClicked(_ sender: Any) {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
            
            let storage = Storage.storage()
            let storageReference = storage.reference()
            
            let mediaFolder = storageReference.child("media")
            
            if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
                
                let uuid = UUID().uuidString
                
                let imageReference = mediaFolder.child("\(uuid).jpg")
                
                imageReference.putData(data) { (storagemetadata, error) in
                    if error != nil {
                        self.errorMessage(title: "Hata", message: error?.localizedDescription ?? "Hata aldınız.")
                    } else {
                        
                        imageReference.downloadURL { (url, error) in
                            if error == nil {
                                let imageUrl = url?.absoluteString
                                
                                if let imageUrl = imageUrl {
                                    
                                    let firestoreDatabase = Firestore.firestore()
                                    
                                    let currentUserEmail = Auth.auth().currentUser?.email
                                    
                                    if currentUserEmail != nil {
                                        
                                        let firestorePost = ["imageurl" : imageUrl, "comment" : self.commentTextField.text!, "email" : currentUserEmail!, "date" : FieldValue.serverTimestamp()] as [String : Any]
                                        
                                        firestoreDatabase.collection("Post").addDocument(data: firestorePost) {
                                            (error) in
                                            if error != nil {
                                                self.errorMessage(title: "Hata", message: error?.localizedDescription ?? "Hata aldınız.")
                                            } else {
                                                
                                                self.activityIndicator.isHidden = true
                                                self.activityIndicator.stopAnimating()
                                                
                                                let alert = UIAlertController(title: "Successfully", message: "Transaction successfull", preferredStyle: .alert)
                                                let okButton = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
                                                    self.imageView.image = UIImage(named: "istanbul")
                                                    self.commentTextField.text = ""
                                                    self.tabBarController?.selectedIndex = 0
                                                }
                                                alert.addAction(okButton)
                                                self.present(alert, animated: true)
                                                
                                            }
                                        
                                        }
                                    
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }
      
    }
    
    func errorMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
}
