//
//  ChatViewController.swift
//  Chat Time
//
//  Created by Bdriah Talaat on 15/06/1444 AH.
//

import UIKit

class ChatViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var nameUserLabel: UILabel!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var messageTextField: UITextField!
    //MARK: VARIABLES
    var user : User!
    var convarsation : Conversation!
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
       
        let otherID: String = convarsation.users.filter { $0 != FirebaseManeger.shared.auth.currentUser!.uid }.first!
        var userData: User? = ChatManeger.shared.getUserData(uid: otherID)
        

        nameUserLabel.text = userData!.fullName
        userImage.setImageFromStringURL(stringURL: (userData?.imageProfil)!)
        userImage.setImageCircler(image: userImage)

        
      
        ChatManeger.shared.didUpdateConversation = { 
            self.chatTableView.reloadData()
        }
    }
    
    //MARK: ACTIONS
    
    @IBAction func messageTextField(_ sender: Any) {
        let uid = FirebaseManeger.shared.auth.currentUser?.uid
        let otherId = convarsation.users.filter{$0 != uid}.first!
        
        
        stateLabel.text = "Typing ..."
       
        
        
    }
    
    @IBAction func messageTextFieldU(_ sender: Any) {
        stateLabel.text = "Offline"
    }
    
    @IBAction func mediaButton(_ sender: Any) {
    }
    @IBAction func sendButton(_ sender: Any) {
        
        if messageTextField.text != nil {
            
            guard let conversation = convarsation else {return}
            guard let text = messageTextField.text else {return}
            guard let userID = FirebaseManeger.shared.auth.currentUser?.uid else {return}
            
            let message = Message(text: text, senderID: userID, timestamp: Date())
            ChatManeger.shared.send(message: message, conversation: conversation)
            
            messageTextField.text = ""
        }
    }
    @IBAction func backButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TabBar") as! TabBar
        present(vc, animated: false)
    }
    //MARK: FUNCTIONS

}
//MARK: EXTENSION
extension ChatViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let index = ChatManeger.shared.conversations.firstIndex(where: {$0.id == convarsation?.id}) else {return 0}
        return ChatManeger.shared.conversations[index].message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let index = ChatManeger.shared.conversations.firstIndex(where: { $0.id == convarsation?.id }){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
            let data = ChatManeger.shared.conversations[index].message[indexPath.row]
            let userId = FirebaseManeger.shared.auth.currentUser!.uid
            
            
            
            if userId != data.senderID{
                cell.chatSenderView.isHidden = true
                cell.chatOtherLabel.text = data.text
                cell.timeOtherLabel.text = "\(Calendar.current.component(.hour, from: data.timestamp)) : \(Calendar.current.component(.minute, from: data.timestamp))"
                
            }else{
                cell.chatOtherView.isHidden = true
                cell.chatSenderLabel.text = data.text
                cell.timeSenderLabel.text = "\(Calendar.current.component(.hour, from: data.timestamp)) : \(Calendar.current.component(.minute, from: data.timestamp))"
                
            }
            
            cell.dateLabel.text = "\(Calendar.current.component(.year, from: data.timestamp))"
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
        
        return cell
    }
    
    
}
