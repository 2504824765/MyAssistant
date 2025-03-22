//
//  DeepseekVC-ChatHistortTVCDelegate.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/21.
//

import Foundation

extension DeepseekVC: ChatHistortTVCDelegate {
    func didFinishingEditChats(_ chats: [Chat]) {
        self.chats = chats
    }
    
    func didChoosedChat(_ chat: Chat) {
        self.messages = chat.messages
        currentRowCount = messages.count
        self.queryTV.reloadData()
    }
}
