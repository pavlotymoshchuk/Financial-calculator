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
        var frame = termsTableView.frame
        frame.size.height = termsTableView.contentSize.height
        termsTableView.frame = frame
    }
    
    // MARK: - Save Button
    @IBAction func saveButton(_ sender: UIButton) {
        if stringIsNumber(rawString: presentOrFutureValueTextField.text!) {
            var terms:[Term] = []
            if gettingTerms(&terms) {
                if checkingForDateIntersection(terms) {
                    addingNewDeposit(terms)
                }
            }
        }
    }
    
    // MARK: - Cancel Button
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Add NewTermButton
    @IBAction func addNewTermButton(_ sender: Any) {
        let numberOfRowsMax = (UIScreen.main.bounds.height - termsTableView.frame.origin.y) / 100
        numberOfRows < Int(numberOfRowsMax) ? numberOfRows+=1 : alert(alertTitle: "Unable to add", alertMessage: "The maximum count of terms are reached", alertActionTitle: "Ok")
        self.termsTableView.reloadData()
    }
    
    // MARK: - Getting terms data and checking for invalid values
    func gettingTerms(_ terms: inout [Term]) -> Bool {
        var answer = true
        let cells = self.termsTableView.visibleCells
        for item in cells {
            let cell = item as! TermTableViewCell
            let dateStart = cell.startDateTermTextField.text!
            let dateEnd = cell.endDateTermTextField.text!
            let percentage = cell.percentageTermTextField.text!
            
            if stringIsNumber(rawString: percentage) && stringIsDate(rawSrring: dateStart) && stringIsDate(rawSrring: dateEnd) {
                terms.append(Term(dateStart: dateStart, dateEnd: dateEnd, percentage: Double(percentage)))
            } else {
                alert(alertTitle: "Unable to save", alertMessage: "Term parameters invalid", alertActionTitle: "Retry")
                answer = false
            }
        }
        return answer
    }
    
    // MARK: - Adding new deposit
    func addingNewDeposit(_ terms: [Term]) {
        // TODO: Обчислити середню ставку відсотків
        if presentOrFutureValuePickerView.selectedRow(inComponent: 0) == 0 {
            // Case presentValue
            // TODO: calculate values
            let futureValue = 0.0
            depositsArray.append(Deposit(presentValue:  Double(presentOrFutureValueTextField.text!), futureValue: futureValue, termsAndPercentages: terms))
        } else {
            // Case futureValue
            // TODO: calculate values
            let presentValue = 0.0
            depositsArray.append(Deposit(presentValue: presentValue, futureValue: Double(presentOrFutureValueTextField.text!), termsAndPercentages: terms))
        }
        // MARK: - Refreshing the tableView from another ViewController
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        dismiss(animated: true, completion: nil) // Dismissing NewDepositController
    }
    
    // MARK: Checking for date intersection
    func checkingForDateIntersection(_ terms: [Term]) -> Bool {
        var answer = true
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        for term in terms {
            if formatter.date(from: term.dateEnd)! <= formatter.date(from: term.dateStart)! {
                answer = false
                break
            }
        }
        for i in 1 ..< terms.count {
            if formatter.date(from: terms[i-1].dateEnd)! > formatter.date(from: terms[i].dateStart)! {
                answer = false
                break
            }
        }
        if !answer {
            alert(alertTitle: "Unable to save", alertMessage: "Terms`s dates are incorrect", alertActionTitle: "Retry")
        }
        return answer
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
        if !answer {
            alert(alertTitle: "Unable to save", alertMessage: "Value parameter invalid", alertActionTitle: "Retry")
        }
        return answer
    }
    
    // MARK: - Is string value for term date
    func stringIsDate(rawSrring: String) -> Bool {
        var answer = true
        if rawSrring.count != 10 {
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
    func alert(alertTitle: String, alertMessage: String, alertActionTitle: String) {
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
