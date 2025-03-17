//
//  Message.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/17.
//

import Foundation

struct Message: Codable {
    var content: String
    var role: String
    var name: String?
}

struct ResponseFormat: Codable {
    var type: String
}
