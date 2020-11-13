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

class NewCreditController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var termsTableView: UITableView!
    @IBOutlet weak var presentOrFutureValuePickerView: UIPickerView!
    @IBOutlet weak var presentOrFutureValueTextField: UITextField!
    
    let presentOrFutureValueArray = ["PV", "FV"]  
    var numberOfRows = 1
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
        
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        presentOrFutureValueTextField.delegate = self
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
                    addingNewCredit(terms)
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
        let lastCell = termsTableView.cellForRow(at: IndexPath(row: numberOfRows-2, section: 0)) as? TermTableViewCell
        let newCell = termsTableView.cellForRow(at: IndexPath(row: numberOfRows-1, section: 0)) as? TermTableViewCell
        newCell?.startDateTermTextField?.text = lastCell?.endDateTermTextField?.text
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
            let inflationOn = cell.inflationSwitch.isOn
            
            if stringIsNumber(rawString: percentage) && stringIsDate(rawSrring: dateStart) && stringIsDate(rawSrring: dateEnd) {
                if inflationOn {
                    let inflation = cell.inflationTermTextField.text!
                    if stringIsNumber(rawString: inflation) {
                        terms.append(Term(dateStart: dateStart, dateEnd: dateEnd, percentage: Double(percentage), inflation: Double(inflation)))
                    } else {
                        alert(alertTitle: "Unable to save", alertMessage: "Term parameters invalid", alertActionTitle: "Retry")
                        answer = false
                    }
                } else {
                    terms.append(Term(dateStart: dateStart, dateEnd: dateEnd, percentage: Double(percentage)))
                }
            } else {
                alert(alertTitle: "Unable to save", alertMessage: "Term parameters invalid", alertActionTitle: "Retry")
                answer = false
            }
        }
        return answer
    }
    
    // MARK: - Adding new credit
    func addingNewCredit(_ terms: [Term]) {
        // TODO: Обчислити середню облікову ставку
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        if presentOrFutureValuePickerView.selectedRow(inComponent: 0) == 0 {
            // Find futureValue
            var futureValue = Double(presentOrFutureValueTextField.text!)
            futureValue = calculatePVOrFV(presentValue: futureValue, futureValue: nil, terms: terms)
            creditsArray.append(Credit(presentValue:  Double(presentOrFutureValueTextField.text!), futureValue: Double(round(100*futureValue!)/100), averageDiscountRate: calculateAverageDiscountRate(terms: terms), mainValue: presentOrFutureValuePickerView.selectedRow(inComponent: 0), termsAndPercentages: terms))
        } else {
            // Find presentValue
            var presentValue = Double(presentOrFutureValueTextField.text!)
            presentValue = calculatePVOrFV(presentValue: nil, futureValue: presentValue, terms: terms)
            creditsArray.append(Credit(presentValue: Double(round(100*presentValue!)/100), futureValue: Double(presentOrFutureValueTextField.text!), averageDiscountRate: calculateAverageDiscountRate(terms: terms), mainValue: presentOrFutureValuePickerView.selectedRow(inComponent: 0), termsAndPercentages: terms))
        }
        // MARK: - Refreshing the tableView from another ViewController
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        dismiss(animated: true, completion: nil) // Dismissing NewCreditController
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
