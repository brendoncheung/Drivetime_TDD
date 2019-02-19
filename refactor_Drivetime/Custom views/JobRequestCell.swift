//
//  JobRequestCell.swift
//  refactor_Drivetime
//
//  Created by Wing Sun Cheung on 1/30/19.
//  Copyright © 2019 Wing Sun Cheung. All rights reserved.
//

import UIKit

class JobRequestCell: UITableViewCell {

    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var pickUpAddress: UILabel!
    @IBOutlet weak var dropOffAddress: UILabel!
    @IBOutlet weak var loadDescription: UILabel!
    @IBOutlet weak var businessEmail: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var priceOffered: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
