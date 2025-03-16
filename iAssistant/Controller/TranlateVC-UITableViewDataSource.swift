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
        return translateHistorys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Reuse cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "TranslateHistoryCellID", for: indexPath) as! TranslateHistoryCell
        // Add content to cell
        cell.lLabel.layer.cornerRadius = 10
        cell.lLabel.layer.masksToBounds = true
        cell.originTextLabel.text = translateHistorys[indexPath.row].originText
        cell.translateText.text = translateHistorys[indexPath.row].translateText
        if translateHistorys[indexPath.row].l == "en2zh-CHS" {
            cell.lLabel.text = "英译中"
        } else if translateHistorys[indexPath.row].l == "zh-CHS2en" {
            cell.lLabel.text = "中译英"
        } else {
            cell.lLabel.text = "小语种"
        }
        return cell
    }
    
    
}
