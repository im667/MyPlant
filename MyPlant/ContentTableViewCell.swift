//
//  ContentTableViewCell.swift
//  MyPlant
//
//  Created by mac on 2021/11/20.
//

import UIKit

class ContentTableViewCell: UITableViewCell {

    static let identifier = "ContentTableViewCell"
    
    @IBOutlet weak var feedImageView: UIImageView!
    
    @IBOutlet weak var feedTitleLabel: UILabel!
    
    @IBOutlet weak var feedContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
