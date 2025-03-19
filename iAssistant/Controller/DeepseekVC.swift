//
//  DeepseekVC.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/15.
//

import UIKit
import Alamofire
import SwiftyJSON

class DeepseekVC: UIViewController, UITableViewDelegate, ChatHistortTVCDelegate, UIGestureRecognizerDelegate {
    func didFinishingEditChats(_ chats: [Chat]) {
        self.chats = chats
    }
    
    func didChoosedChat(_ chat: Chat) {
        self.messages = chat.messages
        currentRowCount = messages.count
        self.queryTV.reloadData()
    }
    

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
//    var responseFormat: ResponseFormat = ResponseFormat(type: "json_object")
    var responseFormat: ResponseFormat = ResponseFormat(type: "text")
    var chatID: String = ""
    var chats: [Chat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.queryTextView.layer.cornerRadius = 10
        
        // Hide navigation back button
        navigationItem.hidesBackButton = true
//        navigationItem.leftBarButtonItem = nil
        // Set slide back enabeld
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.navigationItem.leftBarButtonItem?.image = UIImage(systemName: "plus.circle.fill")
        
        queryTV.delegate = self
        queryTV.dataSource = self
        queryTextView.delegate = self
        
        // 监听键盘弹出
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // 监听键盘收起
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        messages.append(Message(content: "嗨！我是DeepSeek。我可以帮你搜索、答疑、写作，请把你的任务交给我吧～", role: "system"))
        
        let tapGasture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGasture)
        
        chats = readChatHistoryUsingUserDefaults()
        print("Current chats: \(chats)")
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
        let alert = UIAlertController(title: "提示", message: "暂不支持此功能", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: "Default action"), style: .default, handler: { _ in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func newChatButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "提示", message: "你确定要开启新对话吗？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: "Default action"), style: .default, handler: { _ in
            self.addChatToChats()
            self.messages = [Message(content: "嗨！我是DeepSeek。我可以帮你搜索、答疑、写作，请把你的任务交给我吧～", role: "system")]
            self.currentRowCount = self.messages.count
            self.queryTV.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func modelSwitchButtonPressed(_ sender: Any) {
        modelSwitchButton.isSelected = !modelSwitchButton.isSelected
        if modelSwitchButton.isSelected {
            self.model = kDeepSeekReasonerModel
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        if self.queryTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            self.query = queryTextView.text
            messages.append(Message(content: self.queryTextView.text, role: "user"))
            currentRowCount += 1
            queryTV.reloadData()
            
            // Handle response
            print("Start sending request: \"\(self.query)\"")
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(kDeepSeekAPIKey)",
                "Content-Type": "application/json"
            ]
            
            let url = kDeepSeekBaseURL
            let parameters: [String: Any] = [
                "messages": messages.map { ["role": $0.role, "content": $0.content] },
                "model": model,
                "response_format": ["type": responseFormat.type]
            ]
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                if let data = response.value {
                    let responseJSON = JSON(data)
                    print(responseJSON)
                    var message: Message
                    let role: String = responseJSON["choices"][0]["message"]["role"].stringValue
                    var content: String = ""
                    // If it's a R1 model, then load reasoning-content data
                    if responseJSON["model"].stringValue == kDeepSeekReasonerModel {
                        content = responseJSON["choices"][0]["message"]["content"].stringValue
                        let reasoning_content = responseJSON["choices"][0]["message"]["reasoning_content"].stringValue
                        message = Message(content: content, role: role)
                        message.reasoningContent = reasoning_content
                    } else {
                        content = responseJSON["choices"][0]["message"]["content"].stringValue
                        message = Message(content: content, role: role)
                    }
                    self.messages.append(message)
                    self.chatID = self.messages[1].content
                    self.currentRowCount += 1
                    self.queryTV.reloadData()
                }
            }
            scrollToBottom()
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        adjustKeyboardConstraint(notification)
        scrollToBottom()
    }
    
    // 键盘收起时调用
    @objc func keyboardWillHide(_ notification: Notification) {
        // 恢复文本框底部的约束
        bottomConstraint.constant = 30

        // 获取键盘动画的持续时间
        if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    fileprivate func addChatToChats() {
        // When massages' count > 1
        if messages.count > 1 {
            let chat: Chat = Chat(messages: self.messages, chatID: self.messages[1].content)
            
            if !chats.contains(chat) {
                // If one of chats has the same chatID with the new one
                if let index = chats.firstIndex(where: { $0.chatID == chat.chatID }) {
                    // Replace the chat with new chat
                    chats[index] = chat
                    print("Save: Replace")
                } else {
                    // Add new chat
                    chats.append(chat)
                    print("Save: Add")
                }
                saveChatHistoryUsingUserDefaults(self.chats)
            } else {
                print("Have a same request already.")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ChatHistoryID" {
            addChatToChats()
            let chatHistoryTVC = segue.destination as! ChatHistoryTVC
            chatHistoryTVC.chats = self.chats
            chatHistoryTVC.delegate = self
        }
    }

}
