//
//  TranlateVC-UITableViewDataSource.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/12.
//

import Foundation
import UIKit

extension TranslateVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return translateHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kTranslateHistoryCellID, for: indexPath) as! TranslateHistoryCell
        setupTranslateTVUI(cell, indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            translateHistory.remove(at: indexPath.row)
            saveHistorysUsingUserDefaults(historys: translateHistory)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        } else if editingStyle == .insert { }
    }
    
}
