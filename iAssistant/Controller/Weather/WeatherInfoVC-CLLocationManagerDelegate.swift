//
//  WeatherInfoVC-CLLocationManagerDelegate.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/12.
//

import Foundation
import CoreLocation

extension WeatherInfoVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lon = locations[0].coordinate.longitude
        let lat = locations[0].coordinate.latitude
        requestWeatherInfo(lon, lat)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
