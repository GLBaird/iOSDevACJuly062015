//
//  PlaceTableViewCell.swift
//  Places of Interest
//
//  Created by Trainer on 25/03/2015.
//  Copyright (c) 2015 leonbaird. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeDate: UILabel!
    @IBOutlet weak var placeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
