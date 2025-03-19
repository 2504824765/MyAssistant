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
    
    func readGongDeUsingUserDefaults() -> Int64 {
        if let gongDeDate = UserDefaults.standard.data(forKey: "GongDe") {
            do {
                return try JSONDecoder().decode(Int64.self, from: gongDeDate)
            } catch {
                print("ERROR: Failed to decode gongDe: \(error)")
            }
        }
        return 0
    }
    
    func saveGongDeUsingUserDefaults(_ gongDe: Int64) {
        do {
            let data: Data = try JSONEncoder().encode(gongDe)
            UserDefaults.standard.set(data, forKey: "GongDe")
        } catch {
            print("ERROR: Failed to encode GongDe: \(error)")
        }
    }
    
    func startAutoAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            self.electronicFishButtonPressed(self.electronicFishButtonView)
        })
    }
    
    func stopAutoAnimation() {
        timer?.invalidate()
        timer = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        gongDe = readGongDeUsingUserDefaults()
        gongDeLabel.text = gongDe.description
        autoKickSwitch.addTarget(self, action: #selector(autoSwitchChanged(_:)), for: .valueChanged)
        
        self.overrideUserInterfaceStyle = .light
        
        // Hide navigation back button
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = nil
        // Set slide back enabeld
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
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
