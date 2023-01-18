//
//  Conversation.swift
//  Chat Time
//
//  Created by Bdriah Talaat on 17/06/1444 AH.
//

import Foundation
import FirebaseFirestoreSwift
import UIKit

struct Conversation : Identifiable,Codable{
    @DocumentID var DocId : String?
    var id = UUID()
    let users : [String]
    var message : [Message] = []
    var lastMessage : Message?{
        return message.last
    }
    
}

struct Message : Identifiable, Codable {
    var id = UUID()
    let text : String
    //let image : UIImage?
    let senderID : String
    let timestamp : Date
}

struct User : Codable{
    let fullName : String
    let imageProfil : String?
    let email : String
    let uid : String
    @DocumentID var DocId : String?
}
