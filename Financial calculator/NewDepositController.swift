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
    var numberOfRows = 1
        
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        termsTableView.rowHeight = 100
    }
    
    // MARK: - Save Button
    @IBAction func saveButton(_ sender: UIButton) {
        if stringIsNumber(rawString: presentOrFutureValueTextField.text!) {
            // Getting terms data and checking for invalid values
            var terms:[Term] = []
            for i in 0..<numberOfRows {
                let cell = termsTableView.cellForRow(at: IndexPath(row: i, section: 0)) as! TermTableViewCell
                let dateStart = cell.startDateTermTextField.text!
                let dateEnd = cell.endDateTermTextField.text!
                let percentage = cell.percentageTermTextField.text!
                
                if stringIsNumber(rawString: percentage) && stringIsDate(rawSrring: dateStart) && stringIsDate(rawSrring: dateEnd) {
                    terms.append(Term(dateStart: dateStart, dateEnd: dateEnd, percentage: Double(percentage)))
                } else {
                    alert(alertTitle: "Unable to save", alertMessage: "Term parameters invalid", alertActionTitle: "Retry")
                }
            }
            
            // TODO: Adding new deposit and calculating values
            if presentOrFutureValuePickerView.selectedRow(inComponent: 0) == 0 {
                // Case presentValue
                depositsArray.append(Deposit(presentValue:  Double(presentOrFutureValueTextField.text!), futureValue: nil, termsAndPercentages: terms))
            } else {
                // Case futureValue
                depositsArray.append(Deposit(presentValue: nil, futureValue: Double(presentOrFutureValueTextField.text!), termsAndPercentages: terms))
            }

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil) //refresh the tableView from another ViewController
            dismiss(animated: true, completion: nil) // Dismissing NewDepositController
        } else {
            alert(alertTitle: "Unable to save", alertMessage: "Value parameter invalid", alertActionTitle: "Retry")
        }
    }
    
    // MARK: - Cancel Button
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Add NewTermButton
    @IBAction func addNewTermButton(_ sender: Any) {
        numberOfRows+=1
        self.termsTableView.reloadData()
    }
    
    // MARK: - Is string value for deposit
    func stringIsNumber(rawString: String) -> Bool {
        var answer = true
        if let a = Double(rawString) {
            if a >= 0 {
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
    
    // TODO: - Is string value for term date
    func stringIsDate(rawSrring: String) -> Bool {
        var answer = true
        if rawSrring.count > 10 {
            answer = false
        } else {
            for item in rawSrring {
                if (item > "9" || item < "0") && item != "." {
                    answer = false
                    break
                }
            }
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
        return numberOfRows
    }
    
    // MARK: - Заповнення рядків (cellForRowAt)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TermCell", for: indexPath) as? TermTableViewCell {
            cell.numberLabel?.text = String(indexPath.row+1)
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: - Picker View
            
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
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
