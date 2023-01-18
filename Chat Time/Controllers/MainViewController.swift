//
//  ViewController.swift
//  Chat Time
//
//  Created by Bdriah Talaat on 15/06/1444 AH.
//

import UIKit
import Firebase

class MainViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var signUpView: UIView!
    
    //MARK: VARIABLES
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // print(FirebaseManeger.shared.auth.currentUser?.uid)
        
//        let vc = storyboard?.instantiateViewController(withIdentifier: "TabBar") as! TabBar
//        present(vc, animated: false)
//
//        if let user = FirebaseManeger.shared.auth.currentUser?.uid {
//
//            print(user)
//        }
        
        signInView.setCircle(value: 5, View: signInView)
        signUpView.setCircle(value: 5, View: signUpView)
        
        signUpView.setShadow(View: signUpView, shadowRadius: 5, shadowOpacity: 0.4, shadowOffsetWidth: 4, shadowOffsetHeight: 4)
        signInView.setShadow(View: signInView, shadowRadius: 5, shadowOpacity: 0.4, shadowOffsetWidth: 4, shadowOffsetHeight: 4)
    }

    //MARK: ACTIONS
    @IBAction func signUpButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        present(vc, animated: false)
    }
    @IBAction func signInButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        present(vc, animated: false)
    }
    
    //MARK: FUNCTIONS

}
//MARK: EXTENSION

