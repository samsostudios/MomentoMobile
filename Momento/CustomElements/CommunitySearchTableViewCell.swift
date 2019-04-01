//
//  CommunitySearchTableViewCell.swift
//  Momento
//
//  Created by Sam Henry on 3/31/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit

class CommunitySearchTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
