//
//  WeatherInfoVC-CLLocationManagerDelegate.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/12.
//

import Foundation
import CoreLocation
import SwiftyJSON
import Alamofire

extension WeatherInfoVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lon = locations[0].coordinate.longitude
        let lat = locations[0].coordinate.latitude
        // Get the city name from current location
        AF.request("\(kQCityInfoBaseURL)?location=\(lon),\(lat)&key=\(kQWeatherAPIKey)").responseJSON { response in
            self.displayCityInfo(response)
            // Get current city's weather information
            AF.request("\(kQWeatherInfoBaseURL)?location=\(self.city.cityID!)&key=\(kQWeatherAPIKey)").responseJSON { response in
                if let data = response.value {
                    let weatherJSON = JSON(data)
                    self.setWeatherProperties(weatherJSON)
                    self.displayWeatherInfo()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
