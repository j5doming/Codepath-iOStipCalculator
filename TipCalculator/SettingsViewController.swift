//
//  SettingsViewController.swift
//  TipCalculator
//
//  Created by Juan Dominguez on 1/23/19.
//  Copyright © 2019 Juan Dominguez. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // Access UserDefaults for persistence
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var defaultPercentageControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // ensures the default setting control has the most recent default segment selected
        let segmentIndex = defaults.integer(forKey: "PercentageIdxDefault")
        defaultPercentageControl.selectedSegmentIndex = segmentIndex
    }
    
    
    @IBAction func defaultPercentageSetting(_ sender: Any) {
        defaults.set(defaultPercentageControl.selectedSegmentIndex, forKey: "PercentageIdxDefault")
        print(defaultPercentageControl)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}
