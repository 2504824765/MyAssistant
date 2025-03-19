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

class ChatHistoryTVC: UITableViewController, UIGestureRecognizerDelegate {
    var chats: [Chat] = []
    var delegate: ChatHistortTVCDelegate?

    @IBOutlet var chatHistoryTV: UITableView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        // Set slide back enabeld
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
        let alert = UIAlertController(title: "提示", message: "你确定要清除所有的历史记录吗？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: "Default action"), style: .destructive, handler: { _ in
            self.removeAllChatHistory()
            self.chatHistoryTV.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            chats.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveChatHistoryUsingUserDefaults(chats)
            self.delegate!.didFinishingEditChats(self.chats)
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
