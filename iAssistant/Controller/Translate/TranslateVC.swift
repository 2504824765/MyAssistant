//
//  TranslateVC.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/12.
//

import UIKit

class TranslateVC: UIViewController, UITableViewDelegate {
    var translateHistory: [TranslateItem] = []
    var from: String = "auto"
    var to: String = "zh-CHS"

    @IBOutlet weak var commitButton: UIButton!
    @IBOutlet weak var fromLanguegeButton: UIButton!
    @IBOutlet weak var toLanguegeButton: UIButton!
    @IBOutlet weak var translateResultLabel: UILabel!
    @IBOutlet weak var translateTextField: UITextField!
    @IBOutlet weak var translateHistoryTV: UITableView!
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        alert_AreYouSure2DeleteAllTranslateHistory {
            self.deleteAllTranslateHistory()
        }
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        guard let originString = translateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !originString.isEmpty else {
            ProgressHUD.error("请输入要翻译的内容")
            return
        }
        translateTextField.resignFirstResponder()
        translateText(text: originString, from: self.from, to: self.to, appKey: kYDApplicationID, appSecret: kYDTranslateAPIKey) { response, error in
            if let translation = response {
                self.translateResultLabel.text = translation
                ProgressHUD.success("翻译成功")
            }
        }
    }
    
    private func updateLanguageSelection(_ title: String, button: UIButton, languageCode: inout String) {
        if let code = dic[title] {
            button.setTitle(title, for: .normal)
            languageCode = code
        } else {
            button.setTitle("ERROR", for: .normal)
            languageCode = dic[kEnglish] ?? "en"
        }
    }
    
    // Destination languege selections
    @IBAction func toSelection(_ sender: UIAction) {
        translateTextField.resignFirstResponder()
        updateLanguageSelection(sender.title, button: toLanguegeButton, languageCode: &to)
    }
    
    // Origin languege selections
    @IBAction func fromSelection(_ sender: UIAction) {
        translateTextField.resignFirstResponder()
        updateLanguageSelection(sender.title, button: fromLanguegeButton, languageCode: &from)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadHistory()
    }
}
