//
//  ChatHistoryTVC.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/18.
//

import UIKit

// Since chats is passed by DeepseekVC, we need to pass new chats to DeepseekVC if we change the value of chats in this view
protocol ChatHistortTVCDelegate {
    func didFinishingEditChats(_ chats: [Chat])
    func didChoosedChat(_ chat: Chat)
}

class ChatHistoryTVC: UITableViewController {
    var chats: [Chat] = []
    var delegate: ChatHistortTVCDelegate?

    @IBOutlet var chatHistoryTV: UITableView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCellID", for: indexPath) as! ChatHistoryCell
        cell.chatLabel.text = chats[indexPath.row].messages[1].content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let choosedChat: Chat = chats[indexPath.row]
        self.delegate!.didChoosedChat(choosedChat)
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func deleteButtonPressed(_ sender: Any) {
        alert_AreYouSure2ClearAllChatHistory()
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteRowFromDataSource(indexPath)
        } else if editingStyle == .insert { }
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
