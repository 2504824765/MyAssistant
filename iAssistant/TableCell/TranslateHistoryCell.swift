//
//  TranslateHistoryCell.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/12.
//

import UIKit

class TranslateHistoryCell: UITableViewCell {

    @IBOutlet weak var lLabel: UILabel!
    @IBOutlet weak var translateText: UILabel!
    @IBOutlet weak var originTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
