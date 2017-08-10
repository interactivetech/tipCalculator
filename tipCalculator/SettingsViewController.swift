//
//  SettingsViewController.swift
//  tipCalculator
//
//  Created by Andrew Mendez on 8/4/17.
//  Copyright © 2017 Andrew Mendez. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var tip3: UITextField!
    @IBOutlet var tip2: UITextField!
    @IBOutlet var tip1: UITextField!
    
    override func viewDidLoad() {
     
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func updateTips(_ sender: Any) {
        // using NSUserDefaults to do persistance storage
        
        // use UserDefault to update default tip percentages, will
        // be used for tip selection
        
        let defaults = UserDefaults.standard
        
        if let tip_1 = tip1.text{
        defaults.set(Double(tip_1), forKey: "tip1")
        }
        
        if let tip_2 = tip2.text{
        defaults.set(Double(tip_2), forKey: "tip2")
        }
        
        if let tip_3 = tip3.text{
        defaults.set(Double(tip_3), forKey: "tip3")
        }
        
        defaults.synchronize()
        
        //Test: Get value
        print(defaults.double(forKey: "tip1"),defaults.double(forKey: "tip2"),defaults.double(forKey: "tip3"))
        view.endEditing(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTip1(){
        
       
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
