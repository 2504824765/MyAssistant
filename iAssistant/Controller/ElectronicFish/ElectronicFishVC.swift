//
//  ElectronicFishVC.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/13.
//

import UIKit

class ElectronicFishVC: UIViewController, UIGestureRecognizerDelegate {
    var gongDe: Int64 = 0
    
    private var timer: Timer? //设置自动敲击
    
    @IBOutlet weak var electronicFishButtonView: UIButton!
    @IBOutlet weak var gongDeLabel: UILabel!
    @IBOutlet weak var autoKickSwitch: UISwitch!
    
    @IBAction func autoSwitchChanged(_ sender: Any) {
        if autoKickSwitch.isOn {
            startAutoAnimation()
            electronicFishButtonView.isEnabled = false
        } else {
            stopAutoAnimation()
            electronicFishButtonView.isEnabled = true
        }
    }
    @IBAction func electronicFishButtonPressed(_ sender: UIButton) {
        createAndAnimateLabel()
        animateButton()
        gongDe += 1
        self.gongDeLabel.text = gongDe.description
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveGongDeUsingUserDefaults(gongDe)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func startAutoAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            self.electronicFishButtonPressed(self.electronicFishButtonView)
        })
    }
    
    fileprivate func stopAutoAnimation() {
        timer?.invalidate()
        timer = nil
    }
}
