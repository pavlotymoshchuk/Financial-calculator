//
//  AppDelegate.swift
//  Financial calculator
//
//  Created by Павло Тимощук on 02.10.2020.
//  Copyright © 2020 Павло Тимощук. All rights reserved.
//

import UIKit
import CoreData

struct Term {
    var dateStart: String
    var dateEnd: String
    var percentage: Double?
    var inflation: Double?
}

struct Credit {
    var presentValue: Double?
    var futureValue: Double?
    var averageDiscountRate: Double?
    var termsAndPercentages: [Term]
}

var creditsArray: [Credit] = []

var creditIndex = 0
var corection: CGFloat = 3.5

func calculatePVOrFV(presentValue: Double?, futureValue: Double?, terms: [Term]) -> Double? {
    var result: Double? = 0
    var sumOfPercentage: Double = 1
    let calendar = Calendar.current
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    for term in terms {
        let termStart = formatter.date(from: term.dateStart)!
        let termEnd = formatter.date(from: term.dateEnd)!
        let countDays = calendar.component(.day, from: termEnd) - calendar.component(.day, from: termStart)
        let countMonths = calendar.component(.month, from: termEnd) - calendar.component(.month, from: termStart)
        let countYears = calendar.component(.year, from: termEnd) - calendar.component(.year, from: termStart)
        let termDuration = Double(countYears * 360 + countMonths * 30 + countDays) / 360
        if let inflationValue = term.inflation {
            sumOfPercentage -= ((term.percentage! / 100) + (inflationValue / 100)) / (1 + (inflationValue / 100 * termDuration)) * termDuration
        } else {
            sumOfPercentage -= (term.percentage! / 100 * termDuration)
        }
    }
    if presentValue != nil {
        result = presentValue! / sumOfPercentage
    }
    if futureValue != nil {
        result = futureValue! * sumOfPercentage
    }
    if presentValue == nil && futureValue == nil {
        result = nil
    }
    return result
}

func calculateDataForGraph(credit: Credit) -> [CGFloat] {
    var result = [CGFloat]()
    result.append(CGFloat(round(100*credit.presentValue!)/100))
    result.append(CGFloat(round(100*credit.presentValue!)/100))
    var sumOfPercentage: Double = 1
    var sumOfPercentageWithInflations: Double = 1
    let calendar = Calendar.current
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    for i in 1 ... credit.termsAndPercentages.count {
        for j in 0 ..< i  {
            let termStart = formatter.date(from: credit.termsAndPercentages[j].dateStart)!
            let termEnd = formatter.date(from: credit.termsAndPercentages[j].dateEnd)!
            let countDays = calendar.component(.day, from: termEnd) - calendar.component(.day, from: termStart)
            let countMonths = calendar.component(.month, from: termEnd) - calendar.component(.month, from: termStart)
            let countYears = calendar.component(.year, from: termEnd) - calendar.component(.year, from: termStart)
            let termDuration = Double(countYears * 360 + countMonths * 30 + countDays) / 360
            if let inflationValue = credit.termsAndPercentages[j].inflation {
                sumOfPercentageWithInflations -= termDuration * (credit.termsAndPercentages[j].percentage! / 100 + inflationValue / 100) / (1 + (inflationValue / 100 * termDuration))
            } else {
                sumOfPercentageWithInflations -= (credit.termsAndPercentages[j].percentage! / 100 * termDuration)
            }
            sumOfPercentage -= (credit.termsAndPercentages[j].percentage! / 100 * termDuration)
        }
        result.append(CGFloat(round(100 * (credit.presentValue! / sumOfPercentage) )/100))
        result.append(CGFloat(round(100 * (credit.presentValue! / sumOfPercentageWithInflations) )/100))
        sumOfPercentage = 1
        sumOfPercentageWithInflations = 1
    }
    return result
}

func calculateAverageDiscountRate(terms: [Term]) -> Double {
    var averageDiscountRate = Double()
    var sumDiscountRates: Double = 0
    let calendar = Calendar.current
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    for term in terms {
        let dateStart = formatter.date(from: term.dateStart)!
        let dateEnd = formatter.date(from: term.dateEnd)!
        let countDays = calendar.component(.day, from: dateEnd) - calendar.component(.day, from: dateStart)
        let countMonths = calendar.component(.month, from: dateEnd) - calendar.component(.month, from: dateStart)
        let countYears = calendar.component(.year, from: dateEnd) - calendar.component(.year, from: dateStart)
        let termDuration = Double(countYears * 360 + countMonths * 30 + countDays)
        sumDiscountRates += termDuration * term.percentage!
    }
    let dateStart = formatter.date(from: terms[0].dateStart)!
    let dateEnd = formatter.date(from: terms[terms.count-1].dateEnd)!
    let countDays = calendar.component(.day, from: dateEnd) - calendar.component(.day, from: dateStart)
    let countMonths = calendar.component(.month, from: dateEnd) - calendar.component(.month, from: dateStart)
    let countYears = calendar.component(.year, from: dateEnd) - calendar.component(.year, from: dateStart)
    let totalTerm = Double(countYears * 360 + countMonths * 30 + countDays)
    averageDiscountRate = sumDiscountRates / totalTerm
    return Double(round(100*averageDiscountRate)/100)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }

    // MARK: - Core Data stack
    @available(iOS 13.0, *)
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Financial_calculator")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    @available(iOS 13.0, *)
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

