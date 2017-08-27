//
//  MyTravelTableViewCell.swift
//  MyTravel
//
//  Created by hyeong jin kim on 2017. 8. 23..
//  Copyright © 2017년 MJP. All rights reserved.
//

import UIKit

class MyTravelTableViewCell: UITableViewCell {

    @IBOutlet var destinaionLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    

    @IBOutlet var backgroundImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
