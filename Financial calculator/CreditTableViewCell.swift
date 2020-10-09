//
//  TableViewCell.swift
//  Financial calculator
//
//  Created by Павло Тимощук on 03.10.2020.
//  Copyright © 2020 Павло Тимощук. All rights reserved.
//

import UIKit

class CreditTableViewCell: UITableViewCell {
    
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var dateStartLabel: UILabel!
    @IBOutlet weak var dateEndLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var presentValueLabel: UILabel!
    @IBOutlet weak var futureValueLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
