//
//  ViewController.swift
//  Cilmate
//
//  Created by Hansa Anuradha on 12/20/18.
//  Copyright © 2018 Hansa Anuradha. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {

    // Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID : String = "1673431beb2030373dbf969c02455002"
    
    // Declare instance variables
    let locationManager = CLLocationManager()
    
    // IBOutlets
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set up the location manager here
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization() // Request Permission from User
        locationManager.startUpdatingLocation() // Start updating GPS location
    }
    
    //  Location Manager Delegate Methods
    /***********************************************************************************/
    
    // didUpdateLocations method - Tells the deligate that new location data is available
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]   // Get the last location of the locations array which is the most accurate one
        // Check whether the location is valid
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation() // If location is valid, stop updating the location since that is a high power intensive process
            print("Longitude = \(location.coordinate.longitude), Latitude = \(location.coordinate.latitude)")
            
            // Get Latitude and Longitude
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            // Create a dictionaty with latitude, longitude and app id
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
        }
    }
    
    
    // didFailWithError method - Tells the deligate that location manager was unable to retrieve a location value
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable" // Tells the User that the location is unavailable
    }


}

