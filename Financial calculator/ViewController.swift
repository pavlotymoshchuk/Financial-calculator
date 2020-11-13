//
//  ViewController.swift
//  Financial calculator
//
//  Created by Павло Тимощук on 02.10.2020.
//  Copyright © 2020 Павло Тимощук. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableСredits: UITableView!
    
    // MARK: - Refresh
    var refresh = UIRefreshControl()
    @objc func handleRefresh() {
        self.tableСredits.reloadData()
        self.tableСredits.rowHeight = 82
        refresh.endRefreshing()
    }
    
    @objc func refreshing() {
        self.tableСredits.reloadData()
    }
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: - Refresh UITableView
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableСredits.addSubview(refresh)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshing), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        // MARK: - Add data
//        addStartData()
    }
    
    // MARK: - Число всіх рядків (numberOfRowsInSection)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditsArray.count
    }
    
    // MARK: - Заповнення рядків (cellForRowAt)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CreditCell", for: indexPath) as? CreditTableViewCell {
            let item = creditsArray[indexPath.row]
            if item.termsAndPercentages.count > 1 {
                // MARK: - Більше одного терміна
                cell.indexLabel?.text = String(indexPath.row+1)
                cell.dateStartLabel?.text = item.termsAndPercentages[0].dateStart
                cell.dateEndLabel?.text = item.termsAndPercentages[item.termsAndPercentages.count-1].dateEnd
                cell.percentageLabel?.text = (item.averageDiscountRate != nil) ? String(item.averageDiscountRate!) + "%" : String(item.termsAndPercentages[0].percentage!) + "%"
                cell.presentValueLabel?.text = (item.presentValue != nil) ? "PV="+String(item.presentValue!) : "Undefined"
                cell.futureValueLabel?.text = (item.futureValue != nil) ? "FV="+String(item.futureValue!) : "Undefined"
            } else if item.termsAndPercentages.count == 1 {
                // MARK: - Один термін
                cell.indexLabel?.text = String(indexPath.row+1)
                cell.dateStartLabel?.text = item.termsAndPercentages[0].dateStart
                cell.dateEndLabel?.text = item.termsAndPercentages[0].dateEnd
                cell.percentageLabel?.text = String(item.termsAndPercentages[0].percentage!) + "%"
                cell.presentValueLabel?.text = (item.presentValue != nil) ? "PV="+String(item.presentValue!) : "Undefined"
                cell.futureValueLabel?.text = (item.futureValue != nil) ? "FV="+String(item.futureValue!) : "Undefined"
            } else {
                // BUG
                print("!!!BUG!!!")
            }
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        creditIndex = indexPath.row
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailCredit")
        self.present(vc, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func dis() {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

