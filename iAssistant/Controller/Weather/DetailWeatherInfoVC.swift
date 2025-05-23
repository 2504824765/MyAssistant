//
//  DetailWeatherInfoVC.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/12.
//

import UIKit

protocol DetailWeatherInfoVCDelegate {
    func didPressedDetailInfoButton()
}

class DetailWeatherInfoVC: UIViewController, UIGestureRecognizerDelegate {
    var detailWeatherInfoVCDelegate: DetailWeatherInfoVCDelegate?
    var weather = Weather()
    
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var obsTimeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windDir360Label: UILabel!
    @IBOutlet weak var windDirLabel: UILabel!
    @IBOutlet weak var windScaleLabel: UILabel!
    @IBOutlet weak var tempDescriptionLabel: UILabel!
    @IBOutlet weak var tempCompareProgressView: UIProgressView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var windView: UIView!
    @IBOutlet weak var feelsLikeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}
