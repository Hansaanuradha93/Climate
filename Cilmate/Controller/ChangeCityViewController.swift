//
//  ChangeCityViewController.swift
//  Cilmate
//
//  Created by Hansa Anuradha on 12/21/18.
//  Copyright © 2018 Hansa Anuradha. All rights reserved.
//

import UIKit

// Protocol description
protocol ChangeCityDelegate {
    // If you want to be the deligate, you have to implement this method
    func userEnteredANewCityName(city : String)
}

class ChangeCityViewController: UIViewController {

    // Declaire the delegate variable
    var delegate : ChangeCityDelegate?
    
    // IBOutlets
    @IBOutlet weak var changeCityNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // IBActions
    @IBAction func getWeatherButtonPressed(_ sender: UIButton) {
        
        // Get the city name that the user entered in the changeCityNameTextField
        let cityName = changeCityNameTextField.text!
        
        // If we have a delegate set, call the method userEnteredANewCityName
        delegate?.userEnteredANewCityName(city: cityName)
        
        // Dismiss the ChangeCitiViewController to go back to the WeatherViewController
        self.dismiss(animated: true, completion: nil)
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

