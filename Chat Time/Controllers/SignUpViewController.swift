//
//  SignUpViewController.swift
//  Chat Time
//
//  Created by Bdriah Talaat on 15/06/1444 AH.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    //MARK: OUTLETS
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    //MARK: VARIABLES
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        setSetting(View: signUpView)
        setSetting(View: passwordView)
        setSetting(View: emailView)
        setSetting(View: nameView)

        userImage.setCircle(value: 2, View: userImage)
    }
    
    //MARK: ACTIONS
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: false)
    }
    @IBAction func signUpButton(_ sender: Any) {
        if let name = nameTextField.text ,let email = emailTextField.text , let password = passwordTextField.text{
            Auth.auth().createUser(withEmail: email, password: password){ user,error in
                if user != nil{
                   
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as! TabBar
                    
                    ChatManeger.shared.listen {
                        DispatchQueue.main.async{
                            self.persisImageToStorage()
                            self.present(vc, animated: false)
                        }
                    }
                    
                }else{
                    let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
                    let OkAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.destructive) { _ in
                        self.nameTextField.text = ""
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                    }
                    alert.addAction(OkAction)
                    self.present(alert, animated: false)
                }
            }
        }
    }
    @IBAction func clickHere(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        present(vc, animated: false)
    }
    @IBAction func addImageButton(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "Chosse photo from library", style: UIAlertAction.Style.default,handler: { action in
            self.getPhoto(type: UIImagePickerController.SourceType.photoLibrary)
        }))
    
        alert.addAction(UIAlertAction(title: "Take photo from camera", style: UIAlertAction.Style.default,handler: { action in
            self.getPhoto(type: UIImagePickerController.SourceType.camera)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel))
        present(alert, animated: true)
        
    }
    
    //MARK: FUNCTIONS
    func setSetting(View:UIView){
        View.setCircle(value: 5, View: View)
        View.setShadow(View: View, shadowRadius: 5, shadowOpacity: 0.4, shadowOffsetWidth: 4, shadowOffsetHeight: 4)
    }
    
    ///get photo
    func getPhoto(type : UIImagePickerController.SourceType){
       
        /// allow user chose image from your images
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = type
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true)
    }
    
    /// allow this function to convert image to URL
    func persisImageToStorage(){
        guard let uid = FirebaseManeger.shared.auth.currentUser?.uid else { return }
        guard let imageData = self.userImage.image?.jpegData(compressionQuality: 0.5) else { return }

        let ref = FirebaseManeger.shared.storage.reference(withPath: uid)

        ref.putData(imageData, metadata: nil){ metadata, error in
            if let error = error{
                
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: { action in
                    self.nameTextField.text = ""
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                }))
                self.present(alert, animated: false)
            }
            ref.downloadURL { url, Error in
                if let Error = Error{
                    let alert = UIAlertController(title: "Error", message: Error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: { action in
                        self.nameTextField.text = ""
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                    }))
                    self.present(alert, animated: false)
                }
                
                guard let url = url else { return }
                /// allow user store information in firebase storage
                guard let name = self.nameTextField.text else { return }
                guard let email = self.nameTextField.text else { return }
                
                ChatManeger.shared.createUser(profileImage: url, name: name, email: email, uid: uid)
                
            }
        }
        
    }
}
//MARK: EXTENSION
extension SignUpViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info [UIImagePickerController.InfoKey.editedImage] as! UIImage
        dismiss(animated: true)
        userImage.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

extension SignUpViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField{
            emailTextField.becomeFirstResponder()
        }else if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }else{
            view.endEditing(true)
        }
        return true
    }
}
