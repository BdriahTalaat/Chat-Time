//
//  ChatTableViewCell.swift
//  Chat Time
//
//  Created by Bdriah Talaat on 16/06/1444 AH.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    //MARK: OUTLETS
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var chatSenderView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var timeSenderLabel: UILabel!
    @IBOutlet weak var chatOtherView: UIView!
    @IBOutlet weak var chatSenderLabel: UILabel!
    @IBOutlet weak var timeOtherLabel: UILabel!
    @IBOutlet weak var chatOtherLabel: UILabel!
    
    //MARK: LIFE CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dateView.setCircle(value: 5, View: dateView)
        chatSenderView.setCircle(value: 5, View: chatSenderView)
        chatOtherView.setCircle(value: 5, View: chatOtherView)
//        sample.translatesAutoresizingMaskIntoConstraints = false
//        sample.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: 60).isActive = true
//        sample.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
