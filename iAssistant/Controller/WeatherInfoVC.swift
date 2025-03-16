//
//  WeatherInfoVC.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/12.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherInfoVC: UIViewController {
    let locationManager = CLLocationManager()
    let city = City()
    let weather = Weather()
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestLocation()
        
        self.overrideUserInterfaceStyle = .light
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "DetailWeatherInfoVCID" {
            let detailWeatherInfoVC = segue.destination as! DetailWeatherInfoVC
            detailWeatherInfoVC.weather = self.weather
        }
    }
    
}
