//
//  ViewController.swift
//  currencyTake3
//
//  Created by Tyra Neftzger on 12/12/21.
//

import UIKit
import AdSupport
import SailthruMobile

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, STMMessageStreamDelegate, CLLocationManagerDelegate {
    
    var myCurrency:[String] = []
    var myValues:[Double] = []
    var activeCurrency:Double = 0;
    var selectedCurrency:Double = 0;
    var attributes = STMAttributes()


    
    //Objects for Currency Layout
    @IBOutlet weak var currencyInput: UISegmentedControl!
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var output: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    //Segment Control Input - Sets each to country's currency
    @IBAction func inputCurrency(_ sender: UISegmentedControl) {
    
        switch sender.selectedSegmentIndex {
        case 0:
            selectedCurrency = myValues[0]
        case 1:
            selectedCurrency = myValues[1]
        case 2:
            selectedCurrency = myValues[2]
        case 3:
            selectedCurrency = myValues[3]
        default:
            selectedCurrency = myValues[0]
        }
        
        if myValues[2] < 1.1325
        {
            // Construct the object
            let attributes = STMAttributes()
            // Set one or more attributes
            attributes.setBool(true, forKey: "sellKey")
            
            //Replace attribute to True
            attributes.setAttributesMergeRule(.replace)
            
            let sailthruMobile = SailthruMobile()

            // Send to Sailthru Mobile
            sailthruMobile.setAttributes(attributes) { error in
                print("setAttributes returned with possible error: \(String(describing: error))")
            }
            
            
        } else {
            let attributes = STMAttributes()
            // Set one or more attributes
            attributes.setBool(false, forKey: "sellKey")
            
            //Replace attribute to False
            attributes.setAttributesMergeRule(.replace)
            
            let sailthruMobile = SailthruMobile()

            // Send to Sailthru Mobile
            sailthruMobile.setAttributes(attributes) { error in
                print("setAttributes returned with possible error: \(String(describing: error))")
            }
            
        }
        
    }
    
    //Picker View Output - Have to devide into a table rows
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myCurrency.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myCurrency[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeCurrency = myValues[row]
    }
    
    //Button action for converting
    @IBAction func action(_ sender: Any) {
        if (input.text != "")
        {
            output.text =  String(Double(input.text!)! * (activeCurrency/selectedCurrency))
        }
    }
    
    //Loading the Currency Data to the App
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Get device ID and set their device ID as their user ID
        SailthruMobile().deviceID { (deviceID, errorOrNil) in
            SailthruMobile().setUserId(deviceID) { error in
                print("setUserID returned with possible error: \(String(describing: error))")
            }
            if errorOrNil != nil {
                return
            }
        }
        
        //Getting Data from fixer.io and loading into dictionary
        let url = URL(string: "http://data.fixer.io/api/latest?access_key=a32ef4b8e92182c2cef9b225f00a59cb&symbols=EUR,GBP,NZD,USD")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil
            {
                print("ERROR")
            }
            else {
                if let content = data
                {
                    do {
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        if let rates = myJson["rates"] as? NSDictionary
                        {
                            for (key, value) in rates
                            {
                                self.myCurrency.append((key as? String)!)
                                self.myValues.append((value as? Double)!)
                            }
                            self.selectedCurrency = self.myValues[0]
                        }
                    }
                    catch {
                        
                    }
                }
                
                    
            }
            self.pickerView.reloadAllComponents()

            
        }
        task.resume()
    }
    
}

