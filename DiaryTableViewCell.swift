//
//  DiaryTableViewCell.swift
//  ass2-5140
//
//  Created by haofang Liu on 1/10/19.
//  Copyright © 2019 haofang Liu. All rights reserved.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {

    @IBOutlet weak var diaryTitle: UILabel!
    @IBOutlet weak var diaryDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        diaryTitle.numberOfLines = 0
//        diaryDate.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
