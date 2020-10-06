//
//  ViewController.swift
//  Financial calculator
//
//  Created by Павло Тимощук on 02.10.2020.
//  Copyright © 2020 Павло Тимощук. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableDeposits: UITableView!
    
    // MARK: - Refresh
    var refresh = UIRefreshControl()
    @objc func handleRefresh() {
        self.tableDeposits.reloadData()
        refresh.endRefreshing()
    }
    
    @objc func refreshing() {
        self.tableDeposits.reloadData()
    }
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: - Refresh
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableDeposits.addSubview(refresh)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshing), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        
        // MARK: - Add data
//        let term1 = Term(dateStart: 15, dateEnd: 17, percentage: 15)
//        let term2 = Term(dateStart: 18, dateEnd: 22, percentage: 19)
//        depositsArray.append(Deposit(presentValue: 100000, futureValue: nil, termsAndPercentages: [term1]))
//        depositsArray.append(Deposit(presentValue:  nil, futureValue: 300000, termsAndPercentages: [term1,term2]))
    }
    
    // MARK: - Число всіх рядків (numberOfRowsInSection)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return depositsArray.count
    }
    
    // MARK: - Заповнення рядків (cellForRowAt)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DepositCell", for: indexPath) as? DepositTableViewCell
        {
            let item = depositsArray[indexPath.row]
            
            if item.termsAndPercentages.count > 1 { // MARK: - Більше одного терміна
                cell.indexLabel?.text = String(indexPath.row+1)
                cell.dateStartLabel?.text = String(item.termsAndPercentages[0].dateStart)
                cell.dateEndLabel?.text = String(item.termsAndPercentages[item.termsAndPercentages.count-1].dateEnd)
                cell.percentageLabel?.text = "%" // MARK: - Обчислити середню ставку відсотків
                cell.presentValueLabel?.text = (item.presentValue != nil) ? "PV="+String(item.presentValue!) : "undefined"
                cell.futureValueLabel?.text = (item.futureValue != nil) ? "FV="+String(item.futureValue!) : "undefined"
            } else if item.termsAndPercentages.count == 1 { // MARK: - Один термін
                cell.indexLabel?.text = String(indexPath.row+1)
                cell.dateStartLabel?.text = String(item.termsAndPercentages[0].dateStart)
                cell.dateEndLabel?.text = String(item.termsAndPercentages[0].dateEnd)
                cell.percentageLabel?.text = String(item.termsAndPercentages[0].percentage)+"%"
                cell.presentValueLabel?.text = (item.presentValue != nil) ? "PV="+String(item.presentValue!) : "undefined"
                cell.futureValueLabel?.text = (item.futureValue != nil) ? "FV="+String(item.futureValue!) : "undefined"
            } else {
                // BUG
                print("!!!BUG!!!")
            }
            
            return cell
        }
        return UITableViewCell()
    }


}

