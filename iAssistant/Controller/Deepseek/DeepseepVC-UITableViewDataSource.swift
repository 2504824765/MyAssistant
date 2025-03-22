//
//  DeepseepVC-UITableViewDataSource.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/15.
//

import Foundation
import UIKit
import Down

extension DeepseekVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentRowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // If it's DeepSeek Cell
        if ((indexPath.row+1) % 2 == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: kDeepSeekCellID, for: indexPath) as! DeepSeekCell
            setupDeepSeekCellUI(indexPath, cell)
            return cell
        } else { // If it's User Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: kQueryCellID, for: indexPath) as! QueryCell
            setupQueryCellUI(cell, indexPath)
            return cell
        }
    }
    
    func renderMarkdown(markdownString: String, styler: DownStyler) -> NSAttributedString? {
        let down = Down(markdownString: markdownString)
        return try? down.toAttributedString(styler: styler)
    }
    
}
