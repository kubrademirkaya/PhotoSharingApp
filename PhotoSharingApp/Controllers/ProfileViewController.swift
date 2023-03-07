//
//  ProfileViewController.swift
//  PhotoSharingApp
//
//  Created by Kübra Demirkaya on 25.02.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import SDWebImage
import FirebaseStorage
import FirebaseCore

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var postArray = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        firebaseGetData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        firebaseGetData()
    }
    
    func firebaseGetData() {
        
        let firestoreDatabase = Firestore.firestore()
        
        let currentUserEmail = Auth.auth().currentUser?.email
        
        firestoreDatabase.collection("Post").whereField("email", isEqualTo: currentUserEmail).order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            
            //.whereField(userID, isEqualTo: true)
            
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    self.postArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        
                        if let imageUrl = document.get("imageurl") as? String {
                           
                            if let comment = document.get("comment") as? String {
                                
                                if let email = document.get("email") as? String {
                                    
                                    if let date = (document.get("date") as? Timestamp)?.dateValue() as? Date {
                                        
                                         let post = Post(email: email, comment: comment, imageUrl: imageUrl, date: date)
                                             self.postArray.append(post)
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                      
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    func firebaseDeleteData(_ imageurl: String) -> Void {
        
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Post").whereField("imageurl", isEqualTo: imageurl).getDocuments { (querySnapshot, error) in
                if error != nil {
                    print(error)
                } else {
                    for document in querySnapshot!.documents {
                        document.reference.delete()
                    }

                }
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileCell
        cell.userEmailLabel.text = postArray[indexPath.row].email
        cell.commentLabel.text = postArray[indexPath.row].comment
        cell.postImageView.sd_setImage(with: URL(string: self.postArray[indexPath.row].imageUrl))
        cell.dateLabel.text = postArray[indexPath.row].dateString
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let alert = UIAlertController(title: "Warning", message: "Are you sure you want to delete this post?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                
                self.firebaseDeleteData(self.postArray[indexPath.row].imageUrl)
                
                self.postArray.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.bottom)
            }))

            alert.addAction(UIAlertAction(title: "No", style: .cancel))
            
            present(alert, animated: true, completion: nil)
            
            
        }
    }

    
}
