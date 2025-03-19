//
//  Message.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/17.
//

import Foundation

struct Message: Codable, Equatable {
    var content: String
    var role: String
    var name: String?
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.content == rhs.content && lhs.role == rhs.role
    }
}

struct ResponseFormat: Codable {
    var type: String
}
