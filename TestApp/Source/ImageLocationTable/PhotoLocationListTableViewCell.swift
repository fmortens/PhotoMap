//
//  CustomTableViewCell.swift
//  TestApp
//
//  Created by Frank Mortensen on 15/08/2019.
//  Copyright © 2019 Frank Mortensen. All rights reserved.
//

import UIKit

class PhotoLocationListTableViewCell: UITableViewCell {

    
    @IBOutlet var photoView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
