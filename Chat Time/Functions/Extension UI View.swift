//
//  Extension UI View.swift
//  Chat Time
//
//  Created by Bdriah Talaat on 16/06/1444 AH.
//

import Foundation
import UIKit

extension UIView {
    
    func setCircle (value : CGFloat , View :UIView){
        View.layer.cornerRadius = View.frame.height / value
    }
    
    func setShadow(View:UIView , shadowRadius:CGFloat , shadowOpacity: Float , shadowOffsetWidth : Int , shadowOffsetHeight : Int){
        View.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 2)
        View.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        View.layer.shadowRadius = shadowRadius
        View.layer.shadowOpacity = shadowOpacity
    }
}
