//
//  Firebase Menager.swift
//  Chat Time
//
//  Created by Bdriah Talaat on 16/06/1444 AH.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseManeger : NSObject{
    
    let auth : Auth
    let storage : Storage
    let firestore : Firestore
    
    static let shared = FirebaseManeger()
    
    override init() {
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
    }
}
