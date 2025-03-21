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

extension WeatherInfoVC {
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
        self.weather.feelsLike = weatherJSON["now"]["feelsLike"].stringValue
        self.weather.temp = weatherJSON["now"]["temp"].stringValue
        self.weather.obsTime = weatherJSON["now"]["obsTime"].stringValue
        self.weather.wind360 = weatherJSON["now"]["wind360"].stringValue
        self.weather.humidity = weatherJSON["now"]["humidity"].stringValue
        self.weather.windScale = weatherJSON["now"]["windScale"].stringValue
        self.weather.pressure = weatherJSON["now"]["pressure"].stringValue
        self.weather.text = weatherJSON["now"]["text"].stringValue
        self.weather.icon = weatherJSON["now"]["icon"].stringValue
        self.weather.windDir = weatherJSON["now"]["windDir"].stringValue
        self.weather.windSpeed = weatherJSON["now"]["windSpeed"].stringValue
    }
}

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
}

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
                if !self.translateHistorys.contains(where: { $0 == translateItem }) {
                    self.translateHistorys.append(translateItem)
                    print("Save mode: Add")
                    saveHistorysUsingUserDefaults(historys: self.translateHistorys)
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
}

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
}

extension DeepseekVC {
    // 键盘弹出时调用
    func adjustKeyboardConstraint(_ notification: Notification) {
        // 获取键盘的高度
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            
            // 更新文本框底部的约束
            bottomConstraint.constant = keyboardHeight - view.safeAreaInsets.bottom + 45
            
            // 获取键盘动画的持续时间
            if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
                UIView.animate(withDuration: duration) {
                    self.view.layoutIfNeeded()
                }
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
}

extension ChatHistoryTVC {
    func removeAllChatHistory() {
        chats.removeAll()
        saveChatHistoryUsingUserDefaults(chats)
        delegate?.didFinishingEditChats(chats)
    }
}
