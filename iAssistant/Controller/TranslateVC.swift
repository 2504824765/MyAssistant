//
//  TranslateVC.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/12.
//

import UIKit
import Alamofire
import SwiftyJSON
import CommonCrypto
import CryptoKit

class TranslateVC: UIViewController, UITableViewDelegate, UIGestureRecognizerDelegate {
    var translateHistorys: [TranslateItem] = []
    var to: String = "en"
    var from: String = "zh-CHS"

    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var lTabel: UILabel!
    @IBOutlet weak var translateResultLabel: UILabel!
    @IBOutlet weak var translateTextField: UITextField!
    @IBOutlet weak var translateHistoryTV: UITableView!
    @IBOutlet weak var pullDownButton: UIBarButtonItem!
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        print("editDone")
        let originString = translateTextField.text
        translateText(text: originString!, from: self.from, to: self.to, appKey: kYDApplicationID, appSecret: kYDTranslateAPIKey) { response, error in
            if let translation = response {
                self.translateResultLabel.text = translation
            } else if let error = response {
                print("翻译失败：\(error)")
            } else {
                print("未知错误")
            }
        }
    }
    
    @IBAction func translateTextFieldEndEditing(_ sender: UITextField) {

    }
    
    @IBAction func optionSelection(_ sender: UIAction) {
        self.languageButton.setTitle(sender.title, for: .normal)
        if sender.title == "Chinese" {
            self.to = "zh-CHS"
            self.from = "en"
        } else if sender.title == "English" {
            self.to = "en"
            self.from = "zh-CHS"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: .regular)]
        
        // Hide navigation back button
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = nil
        // Set slide back enabeld
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        translateHistoryTV.dataSource = self
        translateHistoryTV.delegate = self
        translateTextField.attributedPlaceholder = NSAttributedString(string: "任意语言翻译...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        self.overrideUserInterfaceStyle = .light
        
        self.translateHistorys = readHistorysUsingUserDefaults()
        
//        if let bundlleID = Bundle.main.bundleIdentifier {
//            UserDefaults.standard.removePersistentDomain(forName: bundlleID)
//        }
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
