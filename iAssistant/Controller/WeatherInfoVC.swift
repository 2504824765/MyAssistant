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

class WeatherInfoVC: UIViewController, UIGestureRecognizerDelegate {
    let locationManager = CLLocationManager()
    let city = City()
    let weather = Weather()
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Hide navigation back button
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = nil
        // Set slide back enabeld
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestLocation()
        
        self.overrideUserInterfaceStyle = .light
        ProgressHUD.animate("正在获取地理信息...", interaction: false)
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
