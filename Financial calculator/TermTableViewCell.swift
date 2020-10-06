//
//  TermTableViewCell.swift
//  Financial calculator
//
//  Created by Павло Тимощук on 06.10.2020.
//  Copyright © 2020 Павло Тимощук. All rights reserved.
//

import UIKit

class TermTableViewCell: UITableViewCell {
    
    @IBOutlet weak var startDateTermLabel: UILabel!
    @IBOutlet weak var endDateTermLabel: UILabel!
    @IBOutlet weak var startDateTermTextField: UITextField!
    @IBOutlet weak var endDateTermTextField: UITextField!
    @IBOutlet weak var percentageTermTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
