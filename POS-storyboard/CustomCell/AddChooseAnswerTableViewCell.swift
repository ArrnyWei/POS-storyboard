//
//  AddChooseAnswerTableViewCell.swift
//  POS-storyboard
//
//  Created by Wei Shih Chi on 2020/1/12.
//  Copyright © 2020 Jetshin. All rights reserved.
//

import UIKit

class AddChooseAnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
