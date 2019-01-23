//
//  ViewController.swift
//  TipCalculator
//
//  Created by Juan Dominguez on 1/23/19.
//  Copyright © 2019 Juan Dominguez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // outlets give access to views, convention to end name with type
    @IBOutlet weak var billField: UITextField!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // use this function to retreive default percentage from settings view
        super.viewWillAppear(animated)
        
        // segment is retrieved from settings view
        let segmentIndex = defaults.integer(forKey: "PercentageIdxDefault")
        tipControl.selectedSegmentIndex = segmentIndex
        
//        print("Selected index from settings \(segmentIndex)")
//        print("inside viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print("inside view did appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        print("inside view will disappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print("inside view did disappear")
    }

    // on tap for main view, dismisses keyboard
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        // Get bill amount
        let bill = Double(billField.text!) ?? 0
        
        // calculate tip and total
        let tipPercentages = [0.15, 0.18, 0.2]
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        
        // update tip and total labels
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }

}

