//
//  EditProfileViewController.swift
//  Chat Time
//
//  Created by Bdriah Talaat on 15/06/1444 AH.
//

import UIKit

class EditProfileViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
   
    //MARK: VARIABLES
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        editImageButton.layer.cornerRadius = editImageButton.frame.height / 5
    }
    

    //MARK: ACTIONS
    
    @IBAction func saveButton(_ sender: Any) {
        ChatManeger.shared.updateData(name: nameTextField.text!, email: emailTextField.text!)
        dismiss(animated: true)
    }
    @IBAction func editImageButton(_ sender: Any) {
    }
    //MARK: FUNCTIONS

}
//MARK: EXTENSION
