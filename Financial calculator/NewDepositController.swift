//
//  NewDepositController.swift
//  Financial calculator
//
//  Created by Павло Тимощук on 03.10.2020.
//  Copyright © 2020 Павло Тимощук. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class NewDepositController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var termsTableView: UITableView!
    @IBOutlet weak var presentOrFutureValuePickerView: UIPickerView!
    @IBOutlet weak var presentOrFutureValueTextField: UITextField!
    
    let presentOrFutureValueArray = ["PV", "FV"]
    var numberOfRowsInSection = 5
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Save Button
    @IBAction func saveButton(_ sender: UIButton) {
        if stringIsNumber(rawString: presentOrFutureValueTextField.text!) {
            // MARK: - Saving deposit and calculating properties
            let term1 = Term(dateStart: 15, dateEnd: 17, percentage: 15)
            let term2 = Term(dateStart: 18, dateEnd: 22, percentage: 19)
            depositsArray.append(Deposit(presentValue:  nil, futureValue: 300000, termsAndPercentages: [term1,term2]))

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
            dismiss(animated: true, completion: nil) // Dismissing NewDepositController
        } else {
            alert(alertTitle: "Unable to save", alertMessage: "Some parameters invalid", alertActionTitle: "Retry")
        }
    }
    
    // MARK: - Cancel Button
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Is string value for deposit
    func stringIsNumber(rawString: String) -> Bool {
        var answer = true
        if let a = Double(rawString) {
            if a > 0 {
                print("VALUE:", a)
            } else {
                print("NOT A VALUE:", rawString)
                answer = false
            }
        } else {
            print("NOT A VALUE:", rawString)
            answer = false
        }
        return answer
    }
    
    // MARK: - Make ALERT
    func alert(alertTitle: String, alertMessage: String, alertActionTitle: String)
    {
        AudioServicesPlaySystemSound(SystemSoundID(4095))
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: alertActionTitle, style: .cancel) { (action) in }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Число всіх рядків (numberOfRowsInSection)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInSection
    }
    
    // MARK: - Заповнення рядків (cellForRowAt)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TermCell", for: indexPath) as? TermTableViewCell {
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: - Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return presentOrFutureValueArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return presentOrFutureValueArray[row]
    }
}
