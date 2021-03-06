//
//  TermTableViewCell.swift
//  Financial calculator
//
//  Created by Павло Тимощук on 06.10.2020.
//  Copyright © 2020 Павло Тимощук. All rights reserved.
//

import UIKit

class TermTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var startDateTermLabel: UILabel!
    @IBOutlet weak var endDateTermLabel: UILabel!
    @IBOutlet weak var startDateTermTextField: UITextField!
    @IBOutlet weak var endDateTermTextField: UITextField!
    @IBOutlet weak var percentageTermTextField: UITextField!
    @IBOutlet weak var inflationTermTextField: UITextField!
    @IBOutlet weak var inflationSwitch: UISwitch!
    
    let datePicker = UIDatePicker()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func showDatePickerForStartDate() {
        datePicker.datePickerMode = .date

        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePickerForStartDate))

        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

        startDateTermTextField.inputAccessoryView = toolbar
        startDateTermTextField.inputView = datePicker
    }
    
    @objc func showDatePickerForEndDate() {
        datePicker.datePickerMode = .date

        let toolbar = UIToolbar();
        toolbar.sizeToFit()

        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePickerForEndDate))
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: true)

        endDateTermTextField.inputAccessoryView = toolbar
        endDateTermTextField.inputView = datePicker
    }
    
    @objc func doneDatePickerForStartDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        startDateTermTextField.text = formatter.string(from: datePicker.date)
        self.contentView.endEditing(true)
    }
    
    @objc func donedatePickerForEndDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        endDateTermTextField.text = formatter.string(from: datePicker.date)
        self.contentView.endEditing(true)
    }

    @objc func cancelDatePicker() {
        self.contentView.endEditing(true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        percentageTermTextField.delegate = self
        inflationTermTextField.delegate = self
        startDateTermTextField.delegate = self
        startDateTermTextField.addTarget(self, action: #selector(showDatePickerForStartDate), for: .editingDidBegin)
        endDateTermTextField.delegate = self
        endDateTermTextField.addTarget(self, action: #selector(showDatePickerForEndDate), for: .editingDidBegin)
        inflationSwitch.addTarget(self, action: #selector(inflationStatus(sender:)), for: .valueChanged)
    }
    
    @objc func inflationStatus(sender: UISwitch!) {
        inflationTermTextField.isUserInteractionEnabled = sender.isOn ? true : false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
