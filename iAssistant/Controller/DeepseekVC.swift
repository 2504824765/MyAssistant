//
//  DeepseekVC.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/15.
//

import UIKit
import Alamofire
import SwiftyJSON
import Down

class DeepseekVC: UIViewController, UITableViewDelegate {
    @IBOutlet weak var queryTextView: UITextView!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var queryTV: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    
    var currentRowCount: Int = 1
    var query: String = ""
    var messages: [Message] = []
    var model: String = "deepseek-chat"
//    var responseFormat: ResponseFormat = ResponseFormat(type: "json_object")
    var responseFormat: ResponseFormat = ResponseFormat(type: "text")
    var chatID: String = ""
    var chats: [Chat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.queryTextView.layer.cornerRadius = 10
        
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
        print(chats)
    }
    
    func readChatHistoryUsingUserDefaults() -> [Chat] {
        if let chatsData = UserDefaults.standard.data(forKey: "AllChats") {
            do {
                return try JSONDecoder().decode([Chat].self, from: chatsData)
            } catch {
                print("ERROR: Failed to decode chatHistory: \(error)")
            }
        }
        return []
    }
    
    deinit {
        // 移除监听
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func saveChatHistoryUsingUserDefaults(_ chats: [Chat]) {
        do {
            let data: Data = try JSONEncoder().encode(chats)
            UserDefaults.standard.set(data, forKey: "AllChats")
        } catch {
            print("Failed to encode chatHistory: \(error)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if messages.count > 1 {
            let chat: Chat = Chat(messages: self.messages, charID: self.chatID)
            chats.append(chat)
            saveChatHistoryUsingUserDefaults(self.chats)
        }
    }
    
    // Tap to hide keyboard
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        queryTextView.resignFirstResponder()
        keyboardWillHide(Notification(name: UIResponder.keyboardWillHideNotification))
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        if self.queryTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            self.query = queryTextView.text
            messages.append(Message(content: self.queryTextView.text, role: "user"))
            currentRowCount += 1
            queryTV.reloadData()
            
            // Handle response
            print("Start sending request")
            
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
//                    print(responseJSON)
                    let message = Message(content: responseJSON["choices"][0]["message"]["content"].stringValue, role: responseJSON["choices"][0]["message"]["role"].stringValue)
                    self.chatID = responseJSON["id"].stringValue
                    self.messages.append(message)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ChatHistoryID" {
            let chatHistoryTVC = segue.destination as! ChatHistoryTVC
            chatHistoryTVC.chats = self.chats
        }
    }

}
