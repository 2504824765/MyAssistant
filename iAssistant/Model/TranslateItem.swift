//
//  TranslateItem.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/12.
//

import Foundation

class TranslateItem: Codable {
    var originText: String
    var translateText: String
    var l: String
    
    init(originText: String, translateText: String, l: String) {
        self.originText = originText
        self.translateText = translateText
        self.l = l
    }
}
