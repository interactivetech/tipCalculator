//
//  ViewController.swift
//  tipCalculator
//
//  Created by Andrew Mendez on 8/4/17.
//  Copyright © 2017 Andrew Mendez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var closeMenu: UITapGestureRecognizer!

    @IBOutlet var billValue: UITextField!
    
    @IBOutlet var TipAmount: UILabel!
    @IBOutlet var resultLabel: UILabel!
    
    @IBOutlet var finalPrice: UILabel!
    
    @IBOutlet var arButton: UIButton!
    @IBOutlet var tipAmountArray: UISegmentedControl!
    @IBOutlet var tipLabel: UILabel!
    
    let timeout:TimeInterval = 60*10;
    
    var tipPercentAmount = [0.18, 0.20, 0.22]
    
    var isEdited:Bool!
    
    @IBAction func hideKeyboard(_ sender: Any) {
        
        view.endEditing(true);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Version: ",UIDevice.current.systemVersion)
        TipAmount.alpha = 0
        finalPrice.alpha = 0
        tipLabel.alpha = 0
        resultLabel.alpha = 0
        tipAmountArray.alpha = 0
        arButton.isHidden = true
        arButton.alpha = 0
        // check if device is running ios11
        if #available(iOS 11.0, *){
            arButton.isHidden = false
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //set text field to be first responder
        billValue.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        print("View will appear")
        
        let defaults = UserDefaults.standard
        // first see if key: lastSaved exists
        let storedBillValue = defaults.double(forKey: "lastSavedBillAmnt")
        
        if storedBillValue != 0.00 {
            let lastSaved = defaults.object(forKey: "lastSaved")
            //else, load bill amount for use
            
            if lastSaved != nil {
            let minutes = Calendar.current.dateComponents([.minute], from: lastSaved as! Date, to: Date()).minute
            
            //if yes: check datetime: lastSaved, if > 10min, show amount
            if minutes! <= 10 {
                //keep decimal so parsable
                billValue.text = String(format: "%.2f", storedBillValue)
            }
            
            else{
                defaults.removeObject(forKey: "lastSavedBillAmnt");
                billValue.text = ""
            }
            
            }
            
        }
        
        
        // load tip percentages when view appears
      
        let tip1 = defaults.double(forKey: "tip1");
        if tip1 != 0 {
            tipPercentAmount[0] = tip1
        }
        
        let tip2 = defaults.double(forKey: "tip2")
        if tip2 != 0 {
            tipPercentAmount[1] = tip2
        }
        
        let tip3 = defaults.double(forKey: "tip3")
        if tip3 != 0 {
            tipPercentAmount[2] = tip3
        }
        
        //remove all segments, update with new values
        tipAmountArray.removeAllSegments()
        var textArray = [String]()
        for elem in tipPercentAmount{
            textArray.append(String(format: "%.2f", elem))
        }
        self.tipAmountArray.removeAllSegments()
        self.tipAmountArray.insertSegment(withTitle: textArray[0], at: 0, animated: true)
        self.tipAmountArray.insertSegment(withTitle: textArray[1], at: 1, animated: true)
        self.tipAmountArray.insertSegment(withTitle: textArray[2], at: 2, animated: true)
        
        //set text field to be first responder
        billValue.becomeFirstResponder()
        resetTextFields()
        
    }
    
    // To ensure that text fields will always be at current locale
    func resetTextFields(){
        
        TipAmount.text = formatValue(number: parseBillValue(text: TipAmount.text))
        finalPrice.text = formatValue(number: parseBillValue(text: finalPrice.text))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("View appeared")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("View will disappear")
        
        let defaults = UserDefaults.standard
        
        //get current locale
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = NumberFormatter.Style.currency
        //save bill amount for later when app restarts
        let billValue =  parseBillValue(text: self.billValue.text)
        
        if billValue != 0.00{
            defaults.set(billValue, forKey: "lastSavedBillAmnt")
            defaults.set(Date(), forKey: "lastSaved")
            defaults.synchronize()
        }
        
        //save datetime user was using app
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("View did disappear")
    }
    
    
    @IBAction func calculateTip(_ sender: Any) {
        
        
        //get current locale
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = NumberFormatter.Style.decimal// convert so its parsable
        //get correct decimal based on current locale

        let bill = parseBillValue(text: billValue.text)
        
        if bill > 0.00{
            
            // animate all ui elements
            
            
            UIView.animate(withDuration: 0.25, animations: {
                self.TipAmount.alpha = 1
                self.finalPrice.alpha = 1
                self.tipLabel.alpha = 1
                self.resultLabel.alpha = 1
                self.tipAmountArray.alpha = 1
                if (!self.arButton.isHidden ){
                    self.arButton.alpha = 1.0
                }

            })
            
            var tip:Double = bill * tipPercentAmount[0];
            
            if  tipAmountArray.selectedSegmentIndex != UISegmentedControlNoSegment{
                tip = bill * tipPercentAmount[ tipAmountArray.selectedSegmentIndex]
            }
            
            let finalValue  = bill + tip
            
            TipAmount.text = formatValue(number: tip)
            finalPrice.text = formatValue(number: finalValue)
        }
        else{
            // animate to zero
            UIView.animate(withDuration: 0.25, animations: {
                self.TipAmount.alpha = 0
                self.finalPrice.alpha = 0
                self.tipLabel.alpha = 0
                self.resultLabel.alpha = 0
                self.tipAmountArray.alpha = 0

            })
        }
        
        
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        //present view view controller
        let arVC = storyboard?.instantiateViewController(withIdentifier: "ARViewController") as! ARViewController
        //pass values to new view controller
        arVC.bill = billValue.text!
        arVC.tip = tipPercentAmount
        arVC.finalBill = finalPrice.text!
        navigationController?.pushViewController(arVC, animated: true)
        
    }
    func parseBillValue(text str:String?) -> Double{
        
        //get current locale
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = NumberFormatter.Style.decimal// set to decimal so its parsable
        //get correct decimal based on current locale
        return formatter.number(from: str!)?.doubleValue ?? 0.00
        
        
    }
    
    func formatValue(number: Double) -> String{
        
        // get the current locale on the user's device
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = NumberFormatter.Style.currency
        //format value to current locale
        let number = NSNumber(value: number)
        let text = formatter.string(from: number)!
        return text
        
    }

}

