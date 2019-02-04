//
//  ViewController.swift
//  TipCalculator
//
//  Created by Juan Dominguez on 1/23/19.
//  Copyright © 2019 Juan Dominguez. All rights reserved.
//

// format Doubles to prevent ex: 40.0 but allow ex: 40.1
extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

struct Constants {
    static let idxDefault = "percentageIdxDefault"
    static let terminationNotifKey = "appWillTerminateOrResign"
    static let dateOnTerminateKey = "date"
    static let billFieldTextKey = "bill"
    static let doubleTwoDecimalFormat = "%.2f"
    static let personCountStr = "personCount"
    static let timeToReenterAmount = 0.2
    
    struct Curreny {
        static let US = "$"
    }
}

import UIKit

class ViewController: UIViewController {
    
    // outlets give access to views, convention to end name with type
    @IBOutlet weak var billField: UITextField!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var splitBillStepper: UIStepper!
    
    @IBOutlet weak var personCountLabel: UILabel!
    
    @IBOutlet weak var perPersonLabel: UILabel!
    
    @IBOutlet weak var perPersonAmountLabel: UILabel!
    
    let defaults = UserDefaults.standard
    let notificationCenter = NotificationCenter.default
    
    var date: NSDate?
    var total: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // make keyboard appear on app launch
//        billField.becomeFirstResponder()
        splitBillStepper.minimumValue = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // use this function to retreive default percentage from settings view
        super.viewWillAppear(animated)
        
        // segment is retrieved from settings view
        let segmentIndex = defaults.integer(forKey: Constants.idxDefault)
        tipControl.selectedSegmentIndex = segmentIndex
        
        // register ViewController as notification observer
        notificationCenter.addObserver(self, selector: #selector(handleTerminationOrResign(_:)), name: Notification.Name(Constants.terminationNotifKey), object: nil)
        
        // if app closed within 10 minutes of reopen, display previous bill amount
        if let oldDate = defaults.value(forKey: Constants.dateOnTerminateKey)  {
            
            let timeInterval = (oldDate as! NSDate).timeIntervalSince(NSDate() as Date)
            
            if abs(timeInterval) / 60 < Constants.timeToReenterAmount {
                billField.text = defaults.string(forKey: Constants.billFieldTextKey)
                
                calculateTip(self)
                
                splitBillStepper.value = Double(defaults.integer(forKey: Constants.personCountStr))
                splitBill(self)
            } else {
                billField.text = ""
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // on tap for main view, dismisses keyboard
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        // Get bill amount
        let bill = Double(billField.text!) ?? 0
        
        // TODO - set bill string as formatted properly.
        defaults.set(bill.clean, forKey: Constants.billFieldTextKey)
        
        // calculate tip and total
        let tipPercentages = [0.15, 0.18, 0.2]
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        
        self.total = total
        
        // update tip and total labels
        tipLabel.text = String(format: Constants.Curreny.US + Constants.doubleTwoDecimalFormat, tip)
        totalLabel.text = String(format: Constants.Curreny.US + Constants.doubleTwoDecimalFormat, total)
    }
    
    // calculate bill split across multiple people
    @IBAction func splitBill(_ sender: Any) {
        let personCount = Int(splitBillStepper.value)
        print(personCount)
        
        if personCount > 1 {
            perPersonLabel.isHidden = false
            perPersonAmountLabel.isHidden = false
            perPersonAmountLabel.text = String(format: Constants.Curreny.US + Constants.doubleTwoDecimalFormat, (total ?? 0) / Double(personCount))
            personCountLabel.text = "\(personCount) Persons"
        } else {
            perPersonLabel.isHidden = true
            perPersonAmountLabel.isHidden = true
            personCountLabel.text = "1 Person"
        }
        
        
    }
    
    
    // this is going to handle when the app terminates 
    @objc func handleTerminationOrResign(_ notification: Notification) {
        defaults.set(NSDate() as Date, forKey: Constants.dateOnTerminateKey)
        
        defaults.set(Int(splitBillStepper.value), forKey: Constants.personCountStr)
    }
    
    
}

