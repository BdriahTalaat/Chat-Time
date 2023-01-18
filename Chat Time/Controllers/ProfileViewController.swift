//
//  ProfileViewController.swift
//  Chat Time
//
//  Created by Bdriah Talaat on 15/06/1444 AH.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var editButtonView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameUserLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    //MARK: VARIABLES
    var user : User!
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        
        getSpacifisUser()
        editButtonView.setCircle(value: 2, View: editButtonView)
        editButtonView.setShadow(View: editButtonView, shadowRadius: 5, shadowOpacity: 0.4, shadowOffsetWidth: 4, shadowOffsetHeight: 4)
        userImage.setCircle(value: 2, View: userImage)
    }
    

    //MARK: ACTIONS
    @IBAction func editProfileButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        present(vc, animated: false)
    }
    
    @IBAction func signOutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let vc = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            present(vc, animated: false)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    //MARK: FUNCTIONS
    func getSpacifisUser() {
       
        guard let uid = FirebaseManeger.shared.auth.currentUser?.uid else { return }
        let userData = ChatManeger.shared.users.first(where: {$0.uid == uid})
        
        //print(userData?.email)
        
        nameUserLabel.text = userData?.fullName
        emailLabel.text = userData?.email
        userImage.setImageFromStringURL(stringURL: userData?.imageProfil ?? "https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-portrait-176256935.jpg")
        
        
    }
}
//MARK: EXTENSION
