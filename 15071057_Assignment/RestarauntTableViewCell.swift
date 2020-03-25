//
//  RestarauntTableViewCell.swift
//  15071057_Assignment
//
//  Created by Liam Russell on 26/02/2018.
//  Copyright © 2018 Liam Russell. All rights reserved.
//

import UIKit

class RestarauntTableViewCell: UITableViewCell {
    
    //label and image for custom cell
    @IBOutlet weak var restarauntLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
