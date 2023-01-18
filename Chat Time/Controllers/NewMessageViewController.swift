//
//  NewMessageViewController.swift
//  Chat Time
//
//  Created by Bdriah Talaat on 16/06/1444 AH.
//

import UIKit
import Firebase

class NewMessageViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var newMessageTableView: UITableView!
    
    //MARK: VARIABLES
    
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        newMessageTableView.delegate = self
        newMessageTableView.dataSource = self
    }

    //MARK: ACTIONS
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    //MARK: FUNCTIONS

}
//MARK: EXTENSION
extension NewMessageViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let uid = FirebaseManeger.shared.auth.currentUser?.uid else {return 0}
        return ChatManeger.shared.users.filter({ $0.uid != uid }).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewMessageTableViewCell", for: indexPath) as! NewMessageTableViewCell
        let uid = FirebaseManeger.shared.auth.currentUser!.uid
        var data = ChatManeger.shared.users.filter({ $0.uid != uid })[indexPath.row]
        
        print(data.fullName)
        
        cell.userImage.setImageFromStringURL(stringURL: data.imageProfil ?? "https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-portrait-176256935.jpg" )
        cell.userImage.setImageCircler(image: cell.userImage)
        cell.nameLabel.text = data.fullName
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let selectedIndex = ChatManeger.shared.users[indexPath.row]
        
        //print(selectedIndex.fullName)
        ChatManeger.shared.createConversation(withId: selectedIndex.uid) {
           
            let conversation = ChatManeger.shared.conversations.first(where: {$0.users.contains(selectedIndex.uid) })

            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            vc.convarsation = conversation
            //print(conversation?.users)
            DispatchQueue.main.async {
                self.present(vc, animated: false)
            }
        }

    }
    
}
