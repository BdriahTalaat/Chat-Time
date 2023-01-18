//
//  ResetPasswordViewController.swift
//  Chat Time
//
//  Created by Bdriah Talaat on 25/06/1444 AH.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var sendButtonView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
   
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        sendButtonView.setCircle(value: 5, View: sendButtonView)
        emailView.setCircle(value: 5, View: emailView)
        
        emailTextField.delegate = self
    }
    
    //MARK: ACTIONS
    @IBAction func sendButton(_ sender: Any) {
        
        FirebaseManeger.shared.auth.sendPasswordReset(withEmail: emailTextField.text!){ error in
            if let error = error{
                
                let alert = UIAlertController.init(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default ,handler: { action in
                    self.emailTextField.text = ""
                }))
                
                self.present(alert, animated: true)
            }
            
            let alert = UIAlertController.init(title: "Hurray", message:"A password reset email has been send!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default ,handler: { action in
                self.dismiss(animated: false)
            }))
            
            self.present(alert, animated: false)
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: false)
    }
}
//MARK: EXTENTION
extension ResetPasswordViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
