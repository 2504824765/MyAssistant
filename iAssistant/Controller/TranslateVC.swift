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
    var from: String = "auto"
    var to: String = "zh-CHS"

    @IBOutlet weak var fromLanguegeButton: UIButton!
    @IBOutlet weak var toLanguegeButton: UIButton!
    @IBOutlet weak var lTabel: UILabel!
    @IBOutlet weak var translateResultLabel: UILabel!
    @IBOutlet weak var translateTextField: UITextField!
    @IBOutlet weak var translateHistoryTV: UITableView!
    @IBOutlet weak var pullDownButton: UIBarButtonItem!
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "提示", message: "你确定要开启清除记录吗？", preferredStyle: .alert)
        // Add Cancel Button
        alert.addAction(UIAlertAction(title: NSLocalizedString("取消", comment: "Cancel action"), style: .cancel, handler: { _ in
            
        }))
        // Add Confirm Button
        alert.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: "Default action"), style: .default, handler: { _ in
            self.translateHistorys = []
            self.translateHistoryTV.reloadData()
            saveHistorysUsingUserDefaults(historys: self.translateHistorys)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        let originString = translateTextField.text
        translateText(text: originString!, from: self.from, to: self.to, appKey: kYDApplicationID, appSecret: kYDTranslateAPIKey) { response, error in
            if let translation = response {
                self.translateResultLabel.text = translation
                ProgressHUD.success("翻译成功")
            } else if let error = response {
                print("翻译失败：\(error)")
            } else {
                print("未知错误")
            }
        }
    }
    
    // Tap to hide keyboard
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        translateTextField.resignFirstResponder()
    }
    
    @IBAction func translateTextFieldEndEditing(_ sender: UITextField) {

    }
    
    @IBAction func toSelection(_ sender: UIAction) {
        translateTextField.resignFirstResponder()
        switch sender.title {
        case kChinese:
            self.toLanguegeButton.setTitle(kChinese, for: .normal)
            self.to = dic[kChinese]!
        case kEnglish:
            self.toLanguegeButton.setTitle(kEnglish, for: .normal)
            self.to = dic[kEnglish]!
        case kFrench:
            self.toLanguegeButton.setTitle(kFrench, for: .normal)
            self.to = dic[kFrench]!
        case kArabic:
            self.toLanguegeButton.setTitle(kArabic, for: .normal)
            self.to = dic[kArabic]!
        case kGerman:
            self.toLanguegeButton.setTitle(kGerman, for: .normal)
            self.to = dic[kGerman]!
        case kSpanish:
            self.toLanguegeButton.setTitle(kSpanish, for: .normal)
            self.to = dic[kSpanish]!
        case kItalian:
            self.toLanguegeButton.setTitle(kItalian, for: .normal)
            self.to = dic[kItalian]!
        case kJapanese:
            self.toLanguegeButton.setTitle(kJapanese, for: .normal)
            self.to = dic[kJapanese]!
        case kKorean:
            self.toLanguegeButton.setTitle(kKorean, for: .normal)
            self.to = dic[kKorean]!
        case kPortuguese:
            self.toLanguegeButton.setTitle(kPortuguese, for: .normal)
            self.to = dic[kPortuguese]!
        case kRussian:
            self.toLanguegeButton.setTitle(kRussian, for: .normal)
            self.to = dic[kRussian]!
        case kVietnamese:
            self.toLanguegeButton.setTitle(kVietnamese, for: .normal)
            self.to = dic[kVietnamese]!
        default:
            self.toLanguegeButton.setTitle("ERROR", for: .normal)
            self.to = dic[kEnglish]!
        }
        print(self.to)
    }
    
    @IBAction func fromSelection(_ sender: UIAction) {
        translateTextField.resignFirstResponder()
        switch sender.title {
        case "auto":
            self.fromLanguegeButton.setTitle("auto", for: .normal)
            self.from = "auto"
        case kChinese:
            self.fromLanguegeButton.setTitle(kChinese, for: .normal)
            self.from = dic[kChinese]!
        case kEnglish:
            self.fromLanguegeButton.setTitle(kEnglish, for: .normal)
            self.from = dic[kEnglish]!
        case kFrench:
            self.fromLanguegeButton.setTitle(kFrench, for: .normal)
            self.from = dic[kFrench]!
        case kArabic:
            self.fromLanguegeButton.setTitle(kArabic, for: .normal)
            self.from = dic[kArabic]!
        case kGerman:
            self.fromLanguegeButton.setTitle(kGerman, for: .normal)
            self.from = dic[kGerman]!
        case kSpanish:
            self.fromLanguegeButton.setTitle(kSpanish, for: .normal)
            self.from = dic[kSpanish]!
        case kItalian:
            self.fromLanguegeButton.setTitle(kItalian, for: .normal)
            self.from = dic[kItalian]!
        case kJapanese:
            self.fromLanguegeButton.setTitle(kJapanese, for: .normal)
            self.from = dic[kJapanese]!
        case kKorean:
            self.fromLanguegeButton.setTitle(kKorean, for: .normal)
            self.from = dic[kKorean]!
        case kPortuguese:
            self.fromLanguegeButton.setTitle(kPortuguese, for: .normal)
            self.from = dic[kPortuguese]!
        case kRussian:
            self.fromLanguegeButton.setTitle(kRussian, for: .normal)
            self.from = dic[kRussian]!
        case kVietnamese:
            self.fromLanguegeButton.setTitle(kVietnamese, for: .normal)
            self.from = dic[kVietnamese]!
        default:
            self.fromLanguegeButton.setTitle("ERROR", for: .normal)
            self.from = dic[kEnglish]!
        }
        print(self.from)
    }
    
    var dic: [String: String] = [
        "Chinese": "zh-CHS",
        "English": "en",
        "French": "fr",
        "Arabic": "ar",
        "German": "de",
        "Spanish": "es",
        "Italian": "it",
        "Japanese": "ja",
        "Korean": "ko",
        "Portuguese": "pt",
        "Russian": "ru",
        "Vietnamese": "vi",
    ]
    
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
        
        toLanguegeButton.setTitle(toLanguegeButton.menu?.children[0].title, for: .normal)
        
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
