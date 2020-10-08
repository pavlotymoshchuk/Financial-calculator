//
//  DetailDepositViewController.swift
//  Financial calculator
//
//  Created by Павло Тимощук on 08.10.2020.
//  Copyright © 2020 Павло Тимощук. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class DetailDepositViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var depositTitleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var presentValueLabel: UILabel!
    @IBOutlet weak var futureValueLabel: UILabel!
    @IBOutlet weak var detailDepositTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addingDataForViews()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func addingDataForViews() {
        detailDepositTableView.rowHeight = 82
        
        depositTitleLabel.text = "Deposit №" + String(depositIndex+1)
        
        if let presVal = depositsArray[depositIndex].presentValue {
            presentValueLabel?.text = String(presVal)
        } else {
            presentValueLabel?.text = "Undefined"
        }
        
        if let futVal = depositsArray[depositIndex].futureValue {
            futureValueLabel?.text = String(futVal)
        } else {
            futureValueLabel?.text = "Undefined"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return depositsArray[depositIndex].termsAndPercentages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DetailDepositTermCell", for: indexPath) as? DetailDepositTermsTableViewCell {
            cell.numberLabel?.text = String(indexPath.row+1)
            cell.termStartLabel?.text = depositsArray[depositIndex].termsAndPercentages[indexPath.row].dateStart
            cell.termEndLabel?.text = depositsArray[depositIndex].termsAndPercentages[indexPath.row].dateEnd
            cell.percentageLabel?.text = String(depositsArray[depositIndex].termsAndPercentages[indexPath.row].percentage!) + "%"
            return cell
        }
        return UITableViewCell()
    }
    
}
