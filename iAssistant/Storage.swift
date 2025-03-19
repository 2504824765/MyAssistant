//
//  Storage.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/13.
//

import Foundation

let kTranslataHistorysKey = "Historys"

func saveHistorysUsingUserDefaults(historys: [TranslateItem]) {
    do {
        let data: Data = try JSONEncoder().encode(historys)
        UserDefaults.standard.set(data, forKey: kTranslataHistorysKey)
    } catch {
        print("ERROR: Failed to encode translateHistorys: \(error)")
    }
}

func readHistorysUsingUserDefaults() -> [TranslateItem] {
    if let historysData = UserDefaults.standard.data(forKey: kTranslataHistorysKey) {
        do {
            return try JSONDecoder().decode([TranslateItem].self, from: historysData)
        } catch {
            print("ERROR: Failed to decode translateHistorys: \(error)")
        }
    }
    return []
}

func saveChatHistoryUsingUserDefaults(_ chats: [Chat]) {
    do {
        let data: Data = try JSONEncoder().encode(chats)
        UserDefaults.standard.set(data, forKey: "AllChats")
    } catch {
        print("Failed to encode chatHistory: \(error)")
    }
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
