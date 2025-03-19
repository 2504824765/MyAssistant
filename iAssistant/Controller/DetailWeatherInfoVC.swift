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
        // Do any additional setup after loading the view.
        // Set attributes of the large title
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: .regular)]
        // Hide navigation back button
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = nil
        // Set slide back enabeld
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        setViewConfig(feelsLikeView)
        setViewConfig(windView)
        self.displayDetailWeatherInfo()
        
        self.overrideUserInterfaceStyle = .light
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
