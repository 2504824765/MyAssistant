//
//  TranslateItem.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/12.
//

import Foundation

class TranslateItem: Codable, Equatable {
    var originText: String
    var translateText: String
    var l: String
    
    init(originText: String, translateText: String, l: String) {
        self.originText = originText
        self.translateText = translateText
        self.l = l
    }
    
    // 实现 Equatable 协议
    static func == (lhs: TranslateItem, rhs: TranslateItem) -> Bool {
        return lhs.originText == rhs.originText &&
               lhs.translateText == rhs.translateText &&
               lhs.l == rhs.l
    }
}
