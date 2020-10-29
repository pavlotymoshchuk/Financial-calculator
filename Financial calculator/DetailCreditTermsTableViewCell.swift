//
//  DetailDepositTermsTableViewCell.swift
//  Financial calculator
//
//  Created by Павло Тимощук on 08.10.2020.
//  Copyright © 2020 Павло Тимощук. All rights reserved.
//

import UIKit

class DetailCreditTermsTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var termStartLabel: UILabel!
    @IBOutlet weak var termEndLabel: UILabel!
    
    @IBOutlet weak var percentageTextField: UITextField!
    @IBOutlet weak var inflationTextField: UITextField!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        percentageTextField.delegate = self
        inflationTextField.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
