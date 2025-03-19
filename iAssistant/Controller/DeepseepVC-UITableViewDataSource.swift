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
        // If DeepSeek Cell
        if ((indexPath.row+1) % 2 == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: kDeepSeekCellID, for: indexPath) as! DeepSeekCell
            let chatContentStyler = DownStyler(
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
            let reasonContentStyler = DownStyler(
                configuration: DownStylerConfiguration(
                    fonts: StaticFontCollection(
                        heading1: .systemFont(ofSize: 21, weight: .bold),
                        heading2: .systemFont(ofSize: 17, weight: .bold),
                        heading3: .systemFont(ofSize: 15, weight: .bold),
                        body: .systemFont(ofSize: 14)
                    ),
                    colors: StaticColorCollection(
                        heading1: .gray,
                        heading2: .gray,
                        heading3: .gray,
                        body: .gray
                    )
                )
            )
            // If there is reasoning_content
            if let reasoning_content = messages[indexPath.row].reasoningContent {
                if let attributedChatString = renderMarkdown(markdownString: messages[indexPath.row].content, styler: chatContentStyler), let attributedReasoningContent = renderMarkdown(markdownString: reasoning_content, styler: reasonContentStyler) {
                    // 创建一个 NSMutableAttributedString
                    let mutableAttributedString = NSMutableAttributedString(attributedString: attributedReasoningContent)
                    let newlineAttributedString = NSAttributedString(string: "\n")
                    mutableAttributedString.append(newlineAttributedString)
                    
                    // 拼接 attributedChatString
                    mutableAttributedString.append(attributedChatString)
                    
                    // 设置 UILabel 的 attributedText
                    cell.deepSeekLabel.attributedText = mutableAttributedString
                    return cell
                }
                return cell
            } else { // If there is not reasong_content
                if let attributedString = renderMarkdown(markdownString: messages[indexPath.row].content, styler: chatContentStyler) {
                    cell.deepSeekLabel.attributedText = attributedString
                }
                cell.layoutIfNeeded()
                return cell
            }
        } else { // If User Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: kQueryCellID, for: indexPath) as! QueryCell
            cell.queryLabel.text = self.messages[indexPath.row].content
            cell.layoutIfNeeded()
            return cell
        }

    }
    
    func renderMarkdown(markdownString: String, styler: DownStyler) -> NSAttributedString? {

        let down = Down(markdownString: markdownString)
        return try? down.toAttributedString(styler: styler)
    }
    
}
