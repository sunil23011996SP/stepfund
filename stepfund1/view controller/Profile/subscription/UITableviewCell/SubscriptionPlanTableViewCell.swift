//
//  SubscriptionPlanTableViewCell.swift
//  stepfund1
//
//  Created by satish prajapati on 07/08/25.
//

import UIKit

class SubscriptionPlanTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPlanName: UILabel!
    @IBOutlet weak var lblPlanAmount: UILabel!
    @IBOutlet weak var lblPlanPercentage: UILabel!
    @IBOutlet weak var imgCheckMark: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
