//
//  UsersViewController.swift
//  Chat Time
//
//  Created by Bdriah Talaat on 15/06/1444 AH.
//

import UIKit

class UsersViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var newMessageView: UIView!
    @IBOutlet weak var usersTableView: UITableView!
    //MARK: VARIABLES
    var users : [User] = []
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        usersTableView.dataSource = self
        usersTableView.delegate = self
        
        newMessageView.setCircle(value: 2, View: newMessageView)
        newMessageView.setShadow(View: newMessageView, shadowRadius: 5, shadowOpacity: 0.4, shadowOffsetWidth: 4, shadowOffsetHeight: 4)
    }
    
    //MARK: ACTIONS
    @IBAction func newMessageButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NewMessageViewController") as! NewMessageViewController
        present(vc, animated: true)
    }
    
    //MARK: FUNCTIONS

}
//MARK: EXTENSION
extension UsersViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ChatManeger.shared.conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersTableViewCell", for: indexPath) as! UsersTableViewCell
        let data = ChatManeger.shared.conversations[indexPath.row]
        
        let otherId:String = data.users.filter({$0 != FirebaseManeger.shared.auth.currentUser?.uid }).first!
        let userData:User? = ChatManeger.shared.getUserData(uid: otherId)
        
        cell.nameLabel.text = userData?.fullName
        cell.userImage.setImageFromStringURL(stringURL: (userData?.imageProfil)!)
        cell.timeMessageLabel.text = " \(Calendar.current.component(.hour, from: data.lastMessage!.timestamp )) :  \(Calendar.current.component(.minute, from: data.lastMessage!.timestamp  ))"
        cell.lastMessageLabel.text = data.lastMessage?.text
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let conversation = ChatManeger.shared.conversations[indexPath.row]
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        vc.convarsation = conversation
        
        DispatchQueue.main.async {
            self.present(vc, animated: false)
        }
        
    }
    
}
