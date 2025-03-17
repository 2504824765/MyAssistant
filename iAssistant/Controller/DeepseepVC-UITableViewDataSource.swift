//
//  DeepseepVC-UITableViewDataSource.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/15.
//

import Foundation
import UIKit

extension DeepseekVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentRowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ((indexPath.row+1) % 2 == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: kDeepSeekCellID, for: indexPath) as! DeepSeekCell
            cell.layoutIfNeeded()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: kQueryCellID, for: indexPath) as! QueryCell
            cell.queryLabel.text = self.query
            cell.layoutIfNeeded()
            return cell
        }

    }
    
}
