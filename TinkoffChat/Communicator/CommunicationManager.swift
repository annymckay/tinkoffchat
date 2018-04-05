//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by Анна Лихтарова on 01.04.2018.
//  Copyright © 2018 Анна Лихтарова. All rights reserved.
//

import Foundation
//typealias ChatInfo = (name: String, message: String?, date: Date?, isUnread: Bool?, isOnline: Bool?)

class CommunicationManager : CommunicatorDelegate {
    var model : ConversationsModel
    
    func didFoundUser(userID: String, userName: String?) {
        var chatInfo : ChatInfo
        chatInfo.name = userName
        if let dialogHistory = model.dialogsHistory[userID] {
            chatInfo.message = dialogHistory.last?.text
        }
        chatInfo.isUnread = true
        chatInfo.isOnline = true
        model.chatList.chats[userID] = chatInfo
        DispatchQueue.main.async {
            self.model.modelChangedCompletion!()
        }
    }
    
    func didLostUser(userID: String) {
        model.chatList.chats[userID] = nil
        DispatchQueue.main.async {
            self.model.modelChangedCompletion!()
        }
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        
    }
    
    func failedToStartAdvertising(error: Error) {
        
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        let date = Date.init()
        print(#function)
        if (model.dialogsHistory[fromUser] == nil) {
            model.dialogsHistory[fromUser] = []
        }
        model.dialogsHistory[fromUser]!.append(Message(isIncoming: true, text: text, date: date))
        
        model.chatList.chats[fromUser]?.message = text
        model.chatList.chats[fromUser]?.date = date
        model.chatList.chats[fromUser]?.isUnread = true
        DispatchQueue.main.async {
            self.model.modelChangedCompletion!()
        }
    }
    init(model: ConversationsModel) {
        self.model = model
    }
    
    
}

protocol CommunicatorDelegate : class {
    //discovering
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    
    //errors
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    //messages
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
}
