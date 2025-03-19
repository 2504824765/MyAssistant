//
//  Chat.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/18.
//

import Foundation

struct Chat: Codable, Equatable {
    // Implements Equatable protocol
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.messages == rhs.messages && lhs.chatID == rhs.chatID
    }
    
    var messages: [Message]
    var chatID: String
}
