//
//  UsersTableViewCell.swift
//  Chat Time
//
//  Created by Bdriah Talaat on 16/06/1444 AH.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    //MARK: OUTLETS
    @IBOutlet weak var timeMessageLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    //MARK: LIFE CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImage.setImageCircler(image: userImage)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
