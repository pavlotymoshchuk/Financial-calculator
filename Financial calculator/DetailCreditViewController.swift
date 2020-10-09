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

class DetailCreditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var creditTitleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var presentValueLabel: UILabel!
    @IBOutlet weak var futureValueLabel: UILabel!
    @IBOutlet weak var detailCreditTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addingDataForViews()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func addingDataForViews() {
        detailCreditTableView.rowHeight = 82
        
        creditTitleLabel.text = "Credit №" + String(creditIndex+1)
        
        if let presVal = creditsArray[creditIndex].presentValue {
            presentValueLabel?.text = String(presVal)
        } else {
            presentValueLabel?.text = "Undefined"
        }
        
        if let futVal = creditsArray[creditIndex].futureValue {
            futureValueLabel?.text = String(futVal)
        } else {
            futureValueLabel?.text = "Undefined"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditsArray[creditIndex].termsAndPercentages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCreditTermCell", for: indexPath) as? DetailCreditTermsTableViewCell {
            cell.numberLabel?.text = String(indexPath.row+1)
            cell.termStartLabel?.text = creditsArray[creditIndex].termsAndPercentages[indexPath.row].dateStart
            cell.termEndLabel?.text = creditsArray[creditIndex].termsAndPercentages[indexPath.row].dateEnd
            cell.percentageLabel?.text = String(creditsArray[creditIndex].termsAndPercentages[indexPath.row].percentage!) + "%"
            return cell
        }
        return UITableViewCell()
    }
    
}
