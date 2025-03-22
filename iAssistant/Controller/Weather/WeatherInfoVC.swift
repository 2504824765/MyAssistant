//
//  WeatherInfoVC.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/12.
//

import UIKit
import CoreLocation

class WeatherInfoVC: UIViewController, UIGestureRecognizerDelegate {
    let locationManager = CLLocationManager()
    let city = City()
    let weather = Weather()
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        setupUI()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailWeatherInfoVCID" {
            let detailWeatherInfoVC = segue.destination as! DetailWeatherInfoVC
            detailWeatherInfoVC.weather = self.weather
        }
    }
    
}
