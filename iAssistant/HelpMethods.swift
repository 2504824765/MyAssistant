//
//  HelpMethods.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/12.
//

import Foundation
import Alamofire
import SwiftyJSON
import CryptoKit
import CommonCrypto
import Down
import CoreLocation

// MARK: - iAssistanttableVC
extension iAssistantTableVC {
    func setupUI() {
        translateIconImageView.layer.cornerRadius = 10
        electronicFishIcon.layer.cornerRadius = 10
        
        self.overrideUserInterfaceStyle = .light
        
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: .regular)]
        // Set daily quote
        AF.request("https://api.xygeng.cn/openapi/one").responseJSON { response in
            if let data = response.value {
                let dataJSON = JSON(data)
//                print(dataJSON)
                let quote = dataJSON["data"]["content"].stringValue
                let tag = dataJSON["data"]["tag"].stringValue
                self.contentLabel.text = "\t\(quote)"
                self.authorLabel.text = "来自：\(tag)"
                // mad这里必须要reloadData，不然tableView不会根据新的数据进行高度自适应
                self.tableView.reloadData()
            } else {
                print("ERROR: Failed to get response")
            }
        }
    }
}

// MARK: - WeatherInfoVC
extension WeatherInfoVC {
    func setupUI() {
        // Hide navigation back button
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = nil
        // Set slide back enabeld
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        locationManager.delegate = self
        locationManager.requestLocation()
        
        self.overrideUserInterfaceStyle = .light
        ProgressHUD.animate("正在获取地理信息...", interaction: false)
    }
    
    func displayCityInfo(_ response: AFDataResponse<Any>) {
        if let data = response.value {
            let cityInfoJSON = JSON(data)
            city.cityName = cityInfoJSON["location"][0]["name"].stringValue
            city.cityProvince = cityInfoJSON["location"][0]["adm1"].stringValue
            city.cityCountry = cityInfoJSON["location"][0]["country"].stringValue
            city.cityID = cityInfoJSON["location"][0]["id"].stringValue
            cityNameLabel.text = "\(city.cityCountry!) \(city.cityProvince!) \(city.cityName!)"
        }
    }
    
    func displayWeatherInfo() {
        weatherIconImageView.image = UIImage(named: weather.icon!)
        tempLabel.text = "\(weather.temp!)˚"
    }
    
    func setWeatherProperties(_ weatherJSON: JSON) {
        weather.feelsLike = weatherJSON["now"]["feelsLike"].stringValue
        weather.temp = weatherJSON["now"]["temp"].stringValue
        let timeString = weatherJSON["now"]["obsTime"].stringValue
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mmZZZZZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        // Analyze update time
        if let date = formatter.date(from: timeString) {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            weather.obsTime = "北京时间 " + components.year!.description + "-" + components.month!.description + "-" + components.day!.description + " " + components.hour!.description + ":" + components.minute!.description
        } else {
            print("日期解析失败")
        }
        weather.wind360 = weatherJSON["now"]["wind360"].stringValue
        weather.humidity = weatherJSON["now"]["humidity"].stringValue
        weather.windScale = weatherJSON["now"]["windScale"].stringValue
        weather.pressure = weatherJSON["now"]["pressure"].stringValue
        weather.text = weatherJSON["now"]["text"].stringValue
        weather.icon = weatherJSON["now"]["icon"].stringValue
        weather.windDir = weatherJSON["now"]["windDir"].stringValue
        weather.windSpeed = weatherJSON["now"]["windSpeed"].stringValue
    }
    
    func requestWeatherInfo(_ lon: CLLocationDegrees, _ lat: CLLocationDegrees) {
        // Get the city name from current location
        AF.request("\(kQCityInfoBaseURL)?location=\(lon),\(lat)&key=\(kQWeatherAPIKey)").responseJSON { response in
            self.displayCityInfo(response)
            // Get current city's weather information
            AF.request("\(kQWeatherInfoBaseURL)?location=\(self.city.cityID!)&key=\(kQWeatherAPIKey)").responseJSON { response in
                if let data = response.value {
                    let weatherJSON = JSON(data)
                    print(weatherJSON)
                    self.setWeatherProperties(weatherJSON)
                    self.displayWeatherInfo()
                    ProgressHUD.dismiss()
                } else {
                    ProgressHUD.error("未知错误\n请联系开发者 ")
                }
            }
        }
    }
}

// MARK: - DetailWeatherInfoVC
extension DetailWeatherInfoVC {
    func setViewConfig(_ view: UIView) {
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.clear
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.gray.cgColor
    }
    
    func displayDetailWeatherInfo() {
        feelsLikeLabel.text = "\(weather.feelsLike!)˚"
        pressureLabel.text = "\(weather.pressure!)百帕"
        obsTimeLabel.text = weather.obsTime
        humidityLabel.text = "\(weather.humidity!)%"
        windDir360Label.text = "\(weather.wind360!)˚"
        windDirLabel.text = weather.windDir
        windScaleLabel.text = "\(weather.windScale!)级"
        if Int(weather.temp!)! < Int(weather.feelsLike!)! {
            tempDescriptionLabel.text = "体感温度比实际气温高"
            tempCompareProgressView.progress = Float(Double(weather.temp!)!/Double(weather.feelsLike!)!)
        } else {
            tempDescriptionLabel.text = "体感温度比实际气温低"
            tempCompareProgressView.progress = Float(Double(weather.feelsLike!)!/Double(weather.temp!)!)
        }
        tempLabel.text = "实际温度：\(weather.temp!)˚"
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: .regular)]
        // Hide navigation back button
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = nil
        // Set slide back enabeld
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        setViewConfig(feelsLikeView)
        setViewConfig(windView)
        self.displayDetailWeatherInfo()
        
        self.overrideUserInterfaceStyle = .light
    }
}

// MARK: - TranslateVC
extension TranslateVC {
    func translateText(text: String, from: String, to: String, appKey: String, appSecret: String, completion: @escaping (String?, Error?) -> Void) {
        let url = kYDTranslateBaseURL
        let salt = String(Int.random(in: 1..<10000))
        let curtime = String(Int(Date().timeIntervalSince1970))
        let truncatedText = truncate(text)
        let signStr = appKey + truncatedText + salt + curtime + appSecret
        let sign = signStr.sha256()
        
        let parameters: [String: Any] = [
            "q": text,
            "from": from,
            "to": to,
            "appKey": appKey,
            "salt": salt,
            "sign": sign,
            "signType": "v3",
            "curtime": curtime
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("响应JSON: \(json)")
                
                // If it's en2zh-CHS
                let translateItem: TranslateItem
                let originText = json["query"].stringValue
                let translateText = json["translation"][0].stringValue
                let l = json["l"].stringValue
                if l == "en2zh-CHS" {
                    let translateText = translateText.removingPercentEncoding
                    print("Decoded translateText while en2zh-CHS: \(String(describing: translateText))")
                    translateItem = TranslateItem(originText: originText, translateText: translateText ?? "ERROR: Failed to decode: \(String(describing: translateText))", l: l)
                } else if l == "zh-CHS2en" { // If it's zh-CHS2en
                    let originText = originText.removingPercentEncoding
                    print("Decoded originText while zh-CHS2en: \(String(describing: originText))")
                    translateItem = TranslateItem(originText: originText ?? "ERROR: Failed to decode: \(String(describing: originText))", translateText: translateText, l: l)
                } else { // If it's not English or Chinese
                    translateItem = TranslateItem(originText: originText, translateText: translateText, l: l)
                    print("小语种")
                }
                let errorCode = json["errorCode"].stringValue
                if errorCode != "0" {
                    if errorCode == "401" {
                        ProgressHUD.error("Error code: \(errorCode)\n开发者API欠费，请联系开发者")
                        return
                    }
                    ProgressHUD.error("Error code: \(errorCode)\n请联系开发者")
                    return
                }
                if !self.translateHistory.contains(where: { $0 == translateItem }) {
                    self.translateHistory.reverse()
                    self.translateHistory.append(translateItem)
                    self.translateHistory.reverse()
                    print("Save mode: Add")
                    saveHistorysUsingUserDefaults(historys: self.translateHistory)
                    self.translateHistoryTV.reloadData()
                } else {
                    print("Save mode: Do nothing")
                }
                
                if let translation = json["translation"].array?.first?.string {
                    completion(translation, nil)
                } else {
                    completion(nil, NSError(domain: "TranslationError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse response"]))
                }
            case .failure(let error):
                print("请求失败: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }
    
    // 截取文本函数
    func truncate(_ text: String) -> String {
        let length = text.count
        if length <= 20 {
            return text
        } else {
            let start = text.prefix(10)
            let end = text.suffix(10)
            return String(start + end)
        }
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: .regular)]
        
        // Hide navigation back button
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = nil
        // Set slide back enabeld
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        translateHistoryTV.dataSource = self
        translateHistoryTV.delegate = self
        translateTextField.attributedPlaceholder = NSAttributedString(string: "任意语言翻译...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        // Set only light mode
        self.overrideUserInterfaceStyle = .light
        
        // 添加轻击手势识别器
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    func loadHistory() {
        translateHistory = readHistoryUsingUserDefaults()
    }
    
    func setupTranslateTVUI(_ cell: TranslateHistoryCell, _ indexPath: IndexPath) {
        cell.lLabel.layer.cornerRadius = 10
        cell.lLabel.layer.masksToBounds = true
        cell.originTextLabel.text = translateHistory[indexPath.row].originText
        cell.translateText.text = translateHistory[indexPath.row].translateText
        if translateHistory[indexPath.row].l == "en2zh-CHS" {
            cell.lLabel.text = "英译中"
        } else if translateHistory[indexPath.row].l == "zh-CHS2en" {
            cell.lLabel.text = "中译英"
        } else {
            cell.lLabel.text = "小语种"
        }
    }
    
    func deleteAllTranslateHistory() {
        translateHistory = []
        translateHistoryTV.reloadData()
        saveHistorysUsingUserDefaults(historys: self.translateHistory)
    }
    
    func alert_AreYouSure2DeleteAllTranslateHistory(confirmAction: @escaping () -> Void) {
        let alert = UIAlertController(title: "提示", message: "你确定要清除所有记录吗？", preferredStyle: .alert)
        // Add Cancel Button
        alert.addAction(UIAlertAction(title: NSLocalizedString("取消", comment: "Cancel action"), style: .cancel, handler: { _ in
        }))
        // Add Confirm Button
        alert.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: "Default action"), style: .destructive, handler: { _ in
            confirmAction()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - String
extension String {
    func sha256() -> String {
        let data = Data(self.utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        _ = data.withUnsafeBytes {
            CC_SHA256($0.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}

// MARK: - ElectronicFishVC
extension ElectronicFishVC {
    func createAndAnimateLabel() {
        // 创建 UILabel
        let label = UILabel()

        label.text = "功德+1"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22)
        label.sizeToFit() // 根据内容调整大小
        
        // 定义中心区域
        let screenWidth = view.bounds.width
        let screenHeight = view.bounds.height
        let centerRegionWidth = screenWidth // 中心区域宽度为屏幕宽度的 100%
        let centerRegionHeight = screenHeight * 0.6 // 中心区域高度为屏幕高度的 60%
        
        // 计算中心区域的起始点
        let centerRegionX = (screenWidth - centerRegionWidth) / 2
        let centerRegionY = (screenHeight - centerRegionHeight) / 2
        
        // 确保 UILabel 完全在中心区域内
        let labelWidth = label.bounds.width
        let labelHeight = label.bounds.height
        let maxX = centerRegionX + centerRegionWidth - labelWidth
        let maxY = centerRegionY + centerRegionHeight - labelHeight
        
        // 在中心区域内随机生成位置
        let randomX = CGFloat.random(in: centerRegionX...maxX)
        let randomY = CGFloat.random(in: centerRegionY...maxY)
        
        label.frame = CGRect(x: randomX, y: randomY, width: labelWidth, height: labelHeight)
        
        // 将 UILabel 添加到视图上
        view.addSubview(label)
        
        // 执行动画
        UIView.animate(withDuration: 1.0, animations: {
            label.transform = CGAffineTransform(translationX: 0, y: -100) // 向上移动
            label.alpha = 0.0 // 逐渐消失
        }) { _ in
            // 动画结束后移除 UILabel
            label.removeFromSuperview()
        }
    }
    
    func animateButton() {
        // 按钮缩放动画
        UIView.animate(withDuration: 0.1, animations: {
            self.electronicFishButtonView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.electronicFishButtonView.transform = CGAffineTransform.identity
            }
        }
    }
    
    func setupUI() {
        gongDe = readGongDeUsingUserDefaults()
        gongDeLabel.text = gongDe.description
        autoKickSwitch.addTarget(self, action: #selector(autoSwitchChanged(_:)), for: .valueChanged)
        
        self.overrideUserInterfaceStyle = .light
        
        // Hide navigation back button
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = nil
        // Set slide back enabeld
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}

// MARK: - DeepseekVC
extension DeepseekVC {
    func setupUI() {
        self.overrideUserInterfaceStyle = .light
        self.queryTextView.layer.cornerRadius = 10
        // Hide navigation back button
        navigationItem.hidesBackButton = true
        // Set slide back enabeld
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.navigationItem.leftBarButtonItem?.image = UIImage(systemName: "plus.circle.fill")
        
        queryTV.delegate = self
        queryTV.dataSource = self
        queryTextView.delegate = self
        // 监听键盘弹出
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        // 监听键盘收起
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        messages.append(Message(content: "嗨！我是DeepSeek。我可以帮你搜索、答疑、写作，请把你的任务交给我吧～", role: "system"))
        
        let tapGasture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGasture)
    }
    
    func loadChatHistory() {
        chats = readChatHistoryUsingUserDefaults()
    }
    
    // 键盘弹出时调用
    func adjustKeyboardConstraint(_ notification: Notification, isShow: Bool) {
        if isShow {
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                let keyboardHeight = keyboardFrame.height
                bottomConstraint.constant = keyboardHeight + 10
                scrollToBottom()
            }
        } else {
            bottomConstraint.constant = 30
        }

        if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // Scroll to bottom
    func scrollToBottom() {
        let lastSection = queryTV.numberOfSections - 1
        let lastRow = queryTV.numberOfRows(inSection: lastSection) - 1
        if lastRow >= 0 {
            let indexPath = IndexPath(row: lastRow, section: lastSection)
            queryTV.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func addChatToChats() {
        // When massages' count > 1
        if messages.count > 1 {
            let chat: Chat = Chat(messages: self.messages, chatID: self.messages[1].content)
            
            if !chats.contains(chat) {
                // If one of chats has the same chatID with the new one
                if let index = chats.firstIndex(where: { $0.chatID == chat.chatID }) {
                    // Replace the chat with new chat
                    chats[index] = chat
                    print("Save: Replace")
                } else {
                    // Add new chat
                    chats.append(chat)
                    print("Save: Add")
                }
                saveChatHistoryUsingUserDefaults(self.chats)
            } else {
                print("Have a same request already.")
            }
        }
    }
    
    func comfirm2StartNewChat() {
        addChatToChats()
        messages = [Message(content: "嗨！我是DeepSeek。我可以帮你搜索、答疑、写作，请把你的任务交给我吧～", role: "system")]
        currentRowCount = self.messages.count
        queryTV.reloadData()
    }
    
    func alert_AreYouSure2StartNewChat(confirmAction: @escaping () -> Void) {
        let alert = UIAlertController(title: "提示", message: "你确定要开启新对话吗？", preferredStyle: .alert)
        // Add Cancel Button
        alert.addAction(UIAlertAction(title: NSLocalizedString("取消", comment: "Cancel action"), style: .cancel, handler: { _ in
            
        }))
        // Add Confirm Button
        alert.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: "Default action"), style: .default, handler: { _ in
            confirmAction()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func alert_netSearchNotAvailable() {
        let alert = UIAlertController(title: "提示", message: "暂不支持此功能", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: "Default action"), style: .default, handler: { _ in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func sendDeepSeekAPIRequest() {
        ProgressHUD.animate("请耐心等待...", .ballVerticalBounce)
        queryTextView.resignFirstResponder()
        query = queryTextView.text
        if query.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return
        }
        messages.append(Message(content: self.queryTextView.text, role: "user"))
        currentRowCount += 1
        queryTV.reloadData()
        
        // Handle response
        print("Start sending request: \"\(self.query)\"")
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(kDeepSeekAPIKey)",
            "Content-Type": "application/json"
        ]
        
        let url = kDeepSeekBaseURL
        let parameters: [String: Any] = [
            "messages": messages.map { ["role": $0.role, "content": $0.content] },
            "model": model,
            "response_format": ["type": responseFormat.type]
        ]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if let data = response.value {
                let responseJSON = JSON(data)
                print(responseJSON)
                var message: Message
                let role: String = responseJSON["choices"][0]["message"]["role"].stringValue
                var content: String = ""
                // If it's a R1 model, then load reasoning-content data
                if responseJSON["model"].stringValue == kDeepSeekReasonerModel {
                    content = responseJSON["choices"][0]["message"]["content"].stringValue
                    let reasoning_content = responseJSON["choices"][0]["message"]["reasoning_content"].stringValue
                    message = Message(content: content, role: role)
                    message.reasoningContent = reasoning_content
                } else {
                    content = responseJSON["choices"][0]["message"]["content"].stringValue
                    message = Message(content: content, role: role)
                }
                self.messages.append(message)
                self.chatID = self.messages[1].content
                self.currentRowCount += 1
                self.queryTV.reloadData()
                ProgressHUD.dismiss()
            }
        }
        scrollToBottom()
    }
    
    func setupDeepSeekCellUI(_ indexPath: IndexPath, _ cell: DeepSeekCell) {
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
            }
        } else { // If there is not reasong_content
            if let attributedString = renderMarkdown(markdownString: messages[indexPath.row].content, styler: chatContentStyler) {
                cell.deepSeekLabel.attributedText = attributedString
            }
            cell.layoutIfNeeded()
        }
    }
    
    func setupQueryCellUI(_ cell: QueryCell, _ indexPath: IndexPath) {
        cell.queryLabel.text = self.messages[indexPath.row].content
        cell.layoutIfNeeded()
    }
}

// MARK: - ChatHistoryTVC
extension ChatHistoryTVC {
    func setupUI() {
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        // Set slide back enabeld
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.tableView.reloadData()
    }
    
    func removeAllChatHistory() {
        chats.removeAll()
        saveChatHistoryUsingUserDefaults(chats)
        delegate?.didFinishingEditChats(chats)
    }
    
    func alert_AreYouSure2ClearAllChatHistory(confirmAcion: @escaping () -> Void) {
        let alert = UIAlertController(title: "提示", message: "你确定要清除所有的历史记录吗？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("取消", comment: "Cancel action"), style: .cancel))
        alert.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: "Default action"), style: .destructive, handler: { _ in
            confirmAcion()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteRowFromDataSource(_ indexPath: IndexPath) {
        chats.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        saveChatHistoryUsingUserDefaults(chats)
        self.delegate!.didFinishingEditChats(self.chats)
        tableView.reloadData()
    }
}

// MARK: - 2048
extension Game2048VC {
    func alert_AreYouSureToStartNewGame(with confirmAction: @escaping () -> Void) {
        let alert = UIAlertController(title: "提示", message: "确定要开始新游戏吗？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
            confirmAction()
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
        }))
        self.present(alert, animated: true)
    }
    
    func UpdatePoints() {
        // Update points
        for i in 0..<gameBoard.size {
            for j in 0..<gameBoard.size {
                if let point = self.value(forKey: "point\(i+1)\(j+1)") as? UILabel {
                    if gameBoard.points[i][j] != 0 {
                        point.text = gameBoard.points[i][j].description
                    } else {
                        point.text = ""
                    }
                    point.superview?.backgroundColor = color4Value(gameBoard.points[i][j])

                }
            }
        }
        scoreLabel.text = gameBoard.score.description
        stepLabel.text = gameBoard.step.description
        if gameBoard.score > gameBoard.heightScore {
            gameBoard.heightScore = gameBoard.score
            heighestScoreLabel.text = gameBoard.heightScore.description
        }
    }
    
    func color4Value(_ value: Int) -> UIColor {
        switch value {
        case 0: return UIColor(red: 238/255, green: 228/255, blue: 218/255, alpha: 1)
        case 2: return UIColor(red: 238/255, green: 228/255, blue: 218/255, alpha: 1)
        case 4: return UIColor(red: 237/255, green: 224/255, blue: 200/255, alpha: 1)
        case 8: return UIColor(red: 242/255, green: 177/255, blue: 121/255, alpha: 1)
        case 16: return UIColor(red: 245/255, green: 149/255, blue: 99/255, alpha: 1)
        case 32: return UIColor(red: 246/255, green: 124/255, blue: 95/255, alpha: 1)
        case 64: return UIColor(red: 246/255, green: 94/255, blue: 59/255, alpha: 1)
        case 128: return UIColor(red: 237/255, green: 207/255, blue: 114/255, alpha: 1)
        case 256: return UIColor(red: 237/255, green: 204/255, blue: 97/255, alpha: 1)
        case 512: return UIColor(red: 237/255, green: 200/255, blue: 80/255, alpha: 1)
        case 1024: return UIColor(red: 237/255, green: 197/255, blue: 63/255, alpha: 1)
        case 2048: return UIColor(red: 237/255, green: 194/255, blue: 46/255, alpha: 1)
        default: return .black
        }
    }
    
    fileprivate func alert_GameOver(with continueAction: @escaping () -> Void, endAction: @escaping () -> Void) {
        let alert = UIAlertController(title: "游戏结束", message: "总得分：\(gameBoard.score)\n可通过回答古诗词问题复活，要继续吗？", preferredStyle: .alert)
        // Add Confirm Button
        alert.addAction(UIAlertAction(title: NSLocalizedString("继续", comment: "Continue game"), style: .default, handler: { _ in
            continueAction()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("结束", comment: "Default action"), style: .cancel, handler: { _ in
            endAction()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func gameOver(index: Int) {
        alert_GameOver {
            self.answerView.isHidden = false
            self.questionLabel.text = "\(self.questions[index]["question"] ?? "No question")\n\(self.questions[index]["options"] ?? "No choices")"
        } endAction: {
            // Update heighest score and save
            if self.gameBoard.score > self.gameBoard.heightScore {
                self.gameBoard.heightScore = self.gameBoard.score
                saveScore2048UsingUserDefaults(self.gameBoard.heightScore)
            }
            self.scoreLabel.text = self.gameBoard.score.description
            self.heighestScoreLabel.text = self.gameBoard.heightScore.description
            saveGameBoardUsingUserDefaults(GameBoard(size: 0))
            self.isOver = true
        }
    }
    
    func setupSwipeGestures() {
        let directions: [UISwipeGestureRecognizer.Direction] = [.up, .down, .left, .right]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            gesture.direction = direction
            boardView.addGestureRecognizer(gesture)
        }
    }
    
    func setupGame() {
        UpdatePoints()
        gameBoard.calculateTotalScore()
        scoreLabel.text = gameBoard.score.description
        gameBoard.heightScore = readScore2048UsingUserDefaults()
        heighestScoreLabel.text = gameBoard.heightScore.description
    }
    
    func alert_AreYouSure2ContinueOlderGame(confirmAction: @escaping () -> Void, cancelAction: @escaping () -> Void) {
        let alert = UIAlertController(title: "提示", message: "要继续之前的游戏吗？", preferredStyle: .alert)
        // Add Confirm Button
        alert.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: "Default action"), style: .default, handler: { _ in
            confirmAction()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("开始新游戏", comment: "Cancel action"), style: .cancel, handler: { _ in
            cancelAction()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupUI() {
        self.overrideUserInterfaceStyle = .light
        // Hide navigation back button
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = nil
        boardView.layer.cornerRadius = 5
        for i in 0..<gameBoard.size {
            for j in 0..<gameBoard.size {
                if let point = self.value(forKey: "point\(i+1)\(j+1)") as? UILabel {
                    point.superview?.layer.cornerRadius = 5
                    point.font = UIFont.boldSystemFont(ofSize: 35)
                    point.textColor = .gray
                }
            }
        }
        scoreLabel.superview?.layer.cornerRadius = 5
        heighestScoreLabel.superview?.layer.cornerRadius = 5
        stepLabel.superview?.layer.cornerRadius = 5
        setupSwipeGestures()
    }
}
