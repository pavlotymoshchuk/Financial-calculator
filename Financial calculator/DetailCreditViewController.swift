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

class DetailCreditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LineChartDelegate, UITextFieldDelegate {
    

    var label = UILabel()
    var lineChart: LineChart!
    
    @IBOutlet weak var creditTitleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var presentValueTextField: UITextField!
    @IBOutlet weak var futureValueTextField: UITextField!
    @IBOutlet weak var averageDiscountRateTextField: UITextField!
    @IBOutlet weak var detailCreditTableView: UITableView!
    @IBOutlet weak var graphViev: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addingDataForViews()
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: scrollView.bounds.height + detailCreditTableView.frame.size.height)
        
        addingGraph()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func addingDataForViews() {
        detailCreditTableView.rowHeight = 82
        detailCreditTableView.frame.size = CGSize(width: CGFloat(self.view.frame.width), height: CGFloat((creditsArray[creditIndex].termsAndPercentages.count * Int(detailCreditTableView.rowHeight)) + 50))
        creditTitleLabel.text = "Credit №" + String(creditIndex+1)
        averageDiscountRateTextField.isEnabled = false
        presentValueTextField.delegate = self
        futureValueTextField.delegate = self
        
        if let presVal = creditsArray[creditIndex].presentValue {
            presentValueTextField?.text = String(presVal)
            corection = CGFloat(1 + (log10(presVal)/2))
        } else {
            presentValueTextField?.text = "Undef"
        }
        
        if let futVal = creditsArray[creditIndex].futureValue {
            futureValueTextField?.text = String(futVal)
        } else {
            futureValueTextField?.text = "Undef"
        }
        
        if let avgDiscRate = creditsArray[creditIndex].averageDiscountRate {
            averageDiscountRateTextField?.text = String(avgDiscRate) + "%"
        } else {
            averageDiscountRateTextField?.text = String(creditsArray[creditIndex].termsAndPercentages[0].percentage!) + "%"
        }
    }
    
    // TODO: Make graph
    func addingGraph() {
        var views: [String: AnyObject] = [:]
        label.text = "Date:  Value: "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.center
        graphViev.frame.origin = CGPoint(x: 0, y: detailCreditTableView.frame.origin.y + detailCreditTableView.frame.size.height + 20)
            
        graphViev.addSubview(label)
        views["label"] = label
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-80-[label]", options: [], metrics: nil, views: views))
        
        //Data arrays
        var simpleValues: [CGFloat] = []
        var valuesWithInflation: [CGFloat] = []
        
        // simple line with custom x axis labels
        var xLabels: [String] = []
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        xLabels.append(formatter.string(from: formatter.date(from: creditsArray[creditIndex].termsAndPercentages[0].dateStart)!))
        for terms in creditsArray[creditIndex].termsAndPercentages {
            xLabels.append(formatter.string(from: formatter.date(from: terms.dateEnd)!))
        }
        
        let allDataForGraph = calculateDataForGraph(credit: creditsArray[creditIndex])
        for i in 0 ..< allDataForGraph.count {
            if i % 2 == 0 {
                valuesWithInflation.append(allDataForGraph[i])
            } else {
                simpleValues.append(allDataForGraph[i])
            }
        }
        
        lineChart = LineChart()
        lineChart.animation.enabled = true
        lineChart.area = true
        lineChart.x.labels.visible = true
        lineChart.x.grid.count = CGFloat(creditsArray[creditIndex].termsAndPercentages.count)
        lineChart.y.grid.count = 5
        lineChart.x.labels.values = xLabels
        lineChart.y.labels.visible = true
        lineChart.addLine(simpleValues)
        lineChart.addLine(valuesWithInflation)
        
        lineChart.x.axis.inset *= corection
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.delegate = self
        graphViev.addSubview(lineChart)
        views["chart"] = lineChart
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[chart]-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[label]-[chart(==200)]", options: [], metrics: nil, views: views))
        
    }
    
    @IBAction func recalculateButton(_ sender: UIButton) {
        for i in 0 ..< creditsArray[creditIndex].termsAndPercentages.count {
            if let cell = detailCreditTableView.cellForRow(at: IndexPath(row: i, section: 0)) as? DetailCreditTermsTableViewCell {
                cell.percentageTextField.delegate = self
                cell.inflationTextField.delegate = self
                let editedPercentage = Double((cell.percentageTextField.text?.replacingOccurrences(of: "%", with: ""))!)
                creditsArray[creditIndex].termsAndPercentages[i].percentage = editedPercentage
                
                let editedInflation = Double((cell.inflationTextField?.text?.replacingOccurrences(of: "%", with: "", options: .regularExpression, range: nil))!)
                creditsArray[creditIndex].termsAndPercentages[i].inflation = editedInflation
            }
        }
        let newPresentValue = Double((presentValueTextField?.text)!)
        let isPresentValueChanged = newPresentValue != creditsArray[creditIndex].presentValue!
        
        let newFutureValue = Double((futureValueTextField?.text)!)
        let isFutureValueChanged = newFutureValue != creditsArray[creditIndex].futureValue!
        
        creditsArray[creditIndex].averageDiscountRate = calculateAverageDiscountRate(terms: creditsArray[creditIndex].termsAndPercentages)
        
        if isPresentValueChanged && !isFutureValueChanged {
            creditsArray[creditIndex].futureValue = calculatePVOrFV(presentValue: newPresentValue, futureValue: nil, terms: creditsArray[creditIndex].termsAndPercentages)
            creditsArray[creditIndex].presentValue = newPresentValue
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
            dismiss(animated: true, completion: nil)
        } else if !isPresentValueChanged && isFutureValueChanged {
            creditsArray[creditIndex].presentValue = calculatePVOrFV(presentValue: nil, futureValue: newFutureValue, terms: creditsArray[creditIndex].termsAndPercentages)
            creditsArray[creditIndex].futureValue = newFutureValue
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
            dismiss(animated: true, completion: nil)
        } else if !isPresentValueChanged && !isFutureValueChanged {
            // TODO:
            creditsArray[creditIndex].futureValue = calculatePVOrFV(presentValue: newPresentValue, futureValue: nil, terms: creditsArray[creditIndex].termsAndPercentages)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
            dismiss(animated: true, completion: nil)
        } else { //if isPresentValueChanged && isFutureValueChanged {
            alert(alertTitle: "Unable to save", alertMessage: "PV and FV both changed", alertActionTitle: "Retry")
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
            cell.percentageTextField?.text = String(creditsArray[creditIndex].termsAndPercentages[indexPath.row].percentage!) + "%"
            cell.inflationTextField?.text = (creditsArray[creditIndex].termsAndPercentages[indexPath.row].inflation != nil) ? String(creditsArray[creditIndex].termsAndPercentages[indexPath.row].inflation!) + "%" : "-"
            return cell
        }
        return UITableViewCell()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func didSelectDataPoint(_ x: CGFloat, yValues: Array<CGFloat>) {
        label.text = "Date: \((Int(x) % 2 == 0) ? creditsArray[creditIndex].termsAndPercentages[Int(x)/2].dateStart : creditsArray[creditIndex].termsAndPercentages[Int(x)/2].dateEnd)  Value: \(yValues)"
    }
    
    
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }
        
    // MARK: - Make ALERT
    func alert(alertTitle: String, alertMessage: String, alertActionTitle: String) {
        AudioServicesPlaySystemSound(SystemSoundID(4095))
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: alertActionTitle, style: .cancel) { (action) in }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
        
    
}
