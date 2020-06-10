//
//  PetTableViewCell.swift
//  Team
//
//  Created by kpugame on 2020/06/11.
//  Copyright © 2020 KPUGAME. All rights reserved.
//

import UIKit

class PetTableViewCell: UITableViewCell {

    @IBOutlet weak var petImageView : UIImageView!
    @IBOutlet weak var happenDate : UILabel!
    @IBOutlet weak var happenPlace : UILabel!
    @IBOutlet weak var sex : UILabel!
    @IBOutlet weak var status : UILabel!
    @IBOutlet weak var specialMark : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
