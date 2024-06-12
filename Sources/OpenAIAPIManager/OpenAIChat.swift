//
//  OpenAIChat.swift
//  vchao
//
//  Created by vchao on 2024/6/12.
//  Copyright © 2024 vchao. All rights reserved.
//

import Foundation
import OpenAIAPIManager

@objc public class OpenAIChat: NSObject {
    static let shared = OpenAIChat()
    public static var requestTask : URLSessionDataTask?
    
    // 定义闭包类型的属性，并且使用 @objc 使其可以被 Objective-C 调用
    @objc var sendTextSuccess: (([String]) -> Void)?
    @objc var sendTextFailed: ((Error) -> Void)?
    @objc var apiKey:String {
        set {
            print("API Key:"+newValue)
            OpenAIAPIManager.shared.apiKey = newValue
        }
        get {
            return OpenAIAPIManager.shared.apiKey
        }
    }
    
    
    @objc public class func sharedInstance() -> OpenAIChat {
        return OpenAIChat.shared
    }
    
    public override init() {
        super.init()
//        OpenAIAPIManager.shared.apiKey = "";
    }
    
    @objc public static func removeChatHistorys() {
        OpenAIAPIManager.shared.historyList.removeAll()
    }
    
    /**
     let userMessage = NSMutableDictionary()
     userMessage.setValue("user", forKey: "role")
     userMessage.setValue(userText, forKey: "content")
     let assistantMessage = NSMutableDictionary()
     assistantMessage.setValue("assistant", forKey: "role")
     assistantMessage.setValue(responseText, forKey: "content")
     */
    @objc public static func setChatHistory(historys: [NSMutableDictionary]) {
        OpenAIAPIManager.shared.historyList.removeAll()
        for item in historys {
            OpenAIAPIManager.shared.historyList.append(item)
        }
    }
    
    @objc public static func sendTextRequest(prompt: String, sendSuccess: @escaping([String]) -> Void, sendFailed: @escaping(Error) -> Void) {
        print("send Text:"+prompt)
        requestTask = OpenAIAPIManager.shared.sendChatRequest(prompt: prompt) { result in
            switch result {
            case .success(let generatedText):
                // Handle the generated text
                sendSuccess(generatedText)
                break
            case .failure(let error):
                // Handle the error
                sendFailed(error)
                break
            }
        }
    }
    
    @objc public static func cancelSendTextRequest() {
        requestTask?.cancel()
    }
}
