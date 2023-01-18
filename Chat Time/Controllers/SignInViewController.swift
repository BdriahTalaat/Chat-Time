//
//  SignInViewController.swift
//  Chat Time
//
//  Created by Bdriah Talaat on 15/06/1444 AH.
//

import UIKit
import Firebase


class SignInViewController: UIViewController {

    //MARK: OUTLETS
    
    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    //MARK: VARIABLES
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.delegate = self
        emailTextField.delegate = self
        
        setSetting(View: signInView)
        setSetting(View: passwordView)
        setSetting(View: emailView)
    }
    //MARK: ACTIONS
    @IBAction func clickHereButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        present(vc, animated: false)
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: false)
    }
    
    @IBAction func signInButton(_ sender: Any) {
        
        if let email = emailTextField.text , let password = passwordTextField.text{
            Auth.auth().signIn(withEmail: email, password: password){ user,error in
                if user != nil{
                   
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as! TabBar
                    
                    ChatManeger.shared.listen {
                        DispatchQueue.main.async {
                            self.present(vc, animated: false)
                        }
                    }
                    
                }else{
                    let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription))", preferredStyle: UIAlertController.Style.alert)
                    let OkAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.destructive) { _ in
                        
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                    }
                    alert.addAction(OkAction)
                    self.present(alert, animated: false)
                }
            }
        }
    }
    
    @IBAction func forgetPasswordButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController") as! ResetPasswordViewController
        
        present(vc, animated: false)
    }
    
    //MARK: FUNCTIONS
    func setSetting(View:UIView){
        View.setCircle(value: 5, View: View)
        View.setShadow(View: View, shadowRadius: 5, shadowOpacity: 0.4, shadowOffsetWidth: 4, shadowOffsetHeight: 4)
    }

}
//MARK: EXTENSION
extension SignInViewController:UISearchTextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }else{
            view.endEditing(true)
        }
        return true
    }
}
