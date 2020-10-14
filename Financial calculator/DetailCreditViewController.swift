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

class DetailCreditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LineChartDelegate {
    
    var label = UILabel()
    var lineChart: LineChart!
    
    
    
    @IBOutlet weak var creditTitleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var presentValueLabel: UILabel!
    @IBOutlet weak var futureValueLabel: UILabel!
    @IBOutlet weak var detailCreditTableView: UITableView!
    @IBOutlet weak var graphViev: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addingDataForViews()
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: scrollView.bounds.height * 2)
        
        addingGraph()
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
    
    // TODO: Make graph
    func addingGraph() {
        var views: [String: AnyObject] = [:]
        label.text = "Date:  Value: "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.center
        
        graphViev.addSubview(label)
        views["label"] = label
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-80-[label]", options: [], metrics: nil, views: views))
        
        //Data arrays
        var simpleValues: [CGFloat] = []
        var valuesWithInflation: [CGFloat] = []
        
        // simple line with custom x axis labels
        var xLabels: [String] = []
        var k = 10000
        for terms in creditsArray[creditIndex].termsAndPercentages {
            xLabels.append(terms.dateStart)
            simpleValues.append(CGFloat(k))
            valuesWithInflation.append(CGFloat(k-100))
            k+=1000
            xLabels.append(terms.dateEnd)
            simpleValues.append(CGFloat(k))
            valuesWithInflation.append(CGFloat(k-100))
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
        
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.delegate = self
        graphViev.addSubview(lineChart)
        views["chart"] = lineChart
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[chart]-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[label]-[chart(==200)]", options: [], metrics: nil, views: views))
        
    }
    
    func draw(_ rect: CGRect) {
        
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
    
}
