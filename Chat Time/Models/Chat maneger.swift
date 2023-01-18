//
//  Chat maneger.swift
//  Chat Time
//
//  Created by Bdriah Talaat on 17/06/1444 AH.
//

import Foundation
import UIKit

class ChatManeger{
    
    //MARK: VARIABLE
    static let shared = ChatManeger()
    var didUpdateConversation : ()->() = {}
    var users : [User] = []
    var conversations : [Conversation] = []
    
    //MARK: FUNCTIONS
    
    //create conversation
    func createConversation(withId : String , _ completion: @escaping () -> ()){
        guard let userID = FirebaseManeger.shared.auth.currentUser?.uid else { return }
        
        Task{
            do{
               
                let snapshot = try await FirebaseManeger.shared.firestore.collection("conversation").whereField("users", isEqualTo: [userID , withId]).getDocuments()
                
                if snapshot.count > 0 {
                    return
                }
                
                let conversation = Conversation(users: [userID , withId])
                let _ = try FirebaseManeger.shared.firestore.collection("conversations").addDocument(from: conversation)
               
                listen {
                    completion()
                }
                
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    //create user
    func createUser(profileImage:URL , name:String , email:String , uid:String){
        let user = User.init(fullName: name, imageProfil: profileImage.absoluteString, email: email, uid: uid)
        
        do{
            
            let save = try FirebaseManeger.shared.firestore.collection("users").addDocument(from: user)
            
        }catch{
            print(error.localizedDescription)
        }
    }
    
    // get all users
    func getUsers() async{
        
        do{
            guard let uid = FirebaseManeger.shared.auth.currentUser?.uid else { return }
            let snapshot = try await FirebaseManeger.shared.firestore.collection("users").getDocuments(source: .server)
            self.users = try snapshot.documents.map{ try $0.data (as: User.self)}
           // print(users)
        }catch{
            print(error.localizedDescription)
        }
    }

    // get user data
    func getUserData(uid : String) async -> User?{
        if let user = users.first(where:{ $0.uid == uid}){
            return user
        }else{
            do{
                let snapshot = try await FirebaseManeger.shared.firestore.collection("users").whereField("uid", isEqualTo: uid).getDocuments(source: .server)
                
                if let user = try snapshot.documents.first?.data(as: User.self){
                    return user
                }
            }catch{
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func getUserData(uid : String) -> User?{
        if let user = users.first(where:{ $0.uid == uid}){
            return user
        }
        return nil
    }
    
    // listen
    func listen (_ completion: @escaping () -> ()){
     
        guard let userId = FirebaseManeger.shared.auth.currentUser?.uid else { return }
        
        Task{
            await getUsers()
            do {
                let snapshot = try await FirebaseManeger.shared.firestore.collection("conversations").whereField("users",arrayContains: userId).getDocuments(source: .server)
                
                print(snapshot)
                
                self.conversations = try snapshot.documents.map({ try $0.data(as: Conversation.self ) })
                var usersIDs : [String] = []
                
                print(conversations)
                
                conversations.forEach { conversation in
                    if let uid = conversation.users.filter({ $0 != userId}).first{
                        if !usersIDs.contains(uid){
                            usersIDs.append(uid)
                        }
                    }
                }
                
                for uid in usersIDs{
                    if let user = await getUserData(uid: uid){
                        if !self.users.contains(where: { $0.uid == user.uid }){
                            self.users.append(user)
                        }
                    }
                }
                
                for conversation in conversations{
                    
                    guard let docId = conversation.DocId else {return}
                    
                    FirebaseManeger.shared.firestore.collection("conversations").document(docId).collection("messages").addSnapshotListener { snapshot, error in
                        
                        if let decuments = snapshot?.documents{
                            
                            do{
                                var messages:[Message] = try decuments.map ({ try $0.data(as: Message.self)})
                                messages.sort { $0.timestamp < $1.timestamp }
                                
                                if let index = self.conversations.firstIndex(where: { $0.id == conversation.id}){
                                    self.conversations[index].message = messages
                                    self.didUpdateConversation()
                                }
                                
                            }catch{
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
                
                completion()
                
            }catch{
                print(error.localizedDescription)
            }
        }
      
    }
    
    // send action
    func send (message : Message , conversation : Conversation ){
        guard let docId = conversation.DocId else{ return }
        
        do{
            
            _ = try FirebaseManeger.shared.firestore.collection("conversations").document(docId).collection("messages").addDocument(from: message)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    // update data for user
    func updateData(name:String , email:String){
        let userEmail = FirebaseManeger.shared.auth.currentUser?.email
        let current = FirebaseManeger.shared.auth.currentUser
        
        for user in users{
            guard let docId = user.DocId else {return}
            print(docId)
            if user.email == userEmail{
               
                if name != nil && email != nil{
                    FirebaseManeger.shared.firestore.collection("users").document(docId).updateData(["fullName":name , "email":email])
                    
                    if email != userEmail{
                        current?.updateEmail(to: email){error in
                            if let  error = error{
                                print(error.localizedDescription)
                            }
                        }
                    }
                    break
                }else{
                    print("error")
                }
            }
        }
    }
    
}
