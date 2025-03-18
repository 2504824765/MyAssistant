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
        if ((indexPath.row+1) % 2 == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: kDeepSeekCellID, for: indexPath) as! DeepSeekCell
            if let attributedString = renderMarkdown(markdownString: messages[indexPath.row].content) {
                cell.deepSeekLabel.attributedText = attributedString
            }
            cell.layoutIfNeeded()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: kQueryCellID, for: indexPath) as! QueryCell
            cell.queryLabel.text = self.query
            cell.layoutIfNeeded()
            return cell
        }

    }
    
    func renderMarkdown(markdownString: String) -> NSAttributedString? {
        let styler = DownStyler(
            configuration: DownStylerConfiguration(
                fonts: StaticFontCollection(
                    heading1: .systemFont(ofSize: 24, weight: .bold),
                    heading2: .systemFont(ofSize: 20, weight: .bold),
                    heading3: .systemFont(ofSize: 18, weight: .bold),
                    body: .systemFont(ofSize: 17)
                ),
                colors: StaticColorCollection(
                    heading1: .black,
                    heading2: .black,
                    heading3: .black,
                    body: .black
                )
            )
        )
        let down = Down(markdownString: markdownString)
        return try? down.toAttributedString(styler: styler)
    }
    
}
