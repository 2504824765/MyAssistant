//
//  DeepseekVC.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/15.
//

import UIKit

class DeepseekVC: UIViewController, UITableViewDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var modelSwitchButton: UIButton!
    @IBOutlet weak var queryTextView: UITextView!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var queryTV: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var newChatButton: UIBarButtonItem!
    
    var currentRowCount: Int = 1
    var query: String = ""
    var messages: [Message] = []
    var model: String = kDeepSeekChatModel
    var responseFormat: ResponseFormat = ResponseFormat(type: "text")
    var chatID: String = ""
    var chats: [Chat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadChatHistory()
    }
    
    deinit {
        // 移除监听
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        addChatToChats()
    }
    
    // Tap to hide keyboard
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        queryTextView.resignFirstResponder()
        keyboardWillHide(Notification(name: UIResponder.keyboardWillHideNotification))
    }
    
    @IBAction func netSearchButtonPressed(_ sender: Any) {
        alert_netSearchNotAvailable()
    }
    
    @IBAction func newChatButtonPressed(_ sender: UIBarButtonItem) {
        alert_AreYouSure2StartNewChat()
    }
    
    @IBAction func modelSwitchButtonPressed(_ sender: Any) {
        modelSwitchButton.isSelected = !modelSwitchButton.isSelected
        if modelSwitchButton.isSelected {
            model = kDeepSeekReasonerModel
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        if self.queryTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            sendDeepSeekAPIRequest()
        } else {
            queryTextView.text = ""
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        adjustKeyboardConstraint(notification, isShow: true)
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        adjustKeyboardConstraint(notification, isShow: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChatHistoryID" {
            addChatToChats()
            let chatHistoryTVC = segue.destination as! ChatHistoryTVC
            chatHistoryTVC.chats = self.chats
            chatHistoryTVC.delegate = self
        }
    }

}
