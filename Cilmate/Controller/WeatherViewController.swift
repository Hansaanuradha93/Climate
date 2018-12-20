//
//  ViewController.swift
//  Cilmate
//
//  Created by Hansa Anuradha on 12/20/18.
//  Copyright © 2018 Hansa Anuradha. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    // Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID : String = "1673431beb2030373dbf969c02455002"
    
    // IBOutlets
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

