//
//  ConversationsModel.swift
//  TinkoffChat
//
//  Created by Анна Лихтарова on 02.04.2018.
//  Copyright © 2018 Анна Лихтарова. All rights reserved.
//

typealias ChatInfo = (name: String?, message: String?, date: Date?, isUnread: Bool?, isOnline: Bool?)
struct Message {
    var isIncoming: Bool
    var text: String
    var date: Date
}
class ChatList {
    var chats : [String : ChatInfo] = [:]
    var onlineCount : Int {
        get {
            var count = 0
            for (_, value) in chats {
                if let isOnline = value.isOnline {
                    if (isOnline) {
                        count = count + 1 }}
            }
            return count
        }
    }
    var offlineCount : Int {
        get {
            return chats.count - onlineCount
        }
    }
    // var
}
class ConversationsModel {
    var modelChangedCompletion : (() -> ())?
    var chatList : ChatList = ChatList()
    var dialogsHistory : [String : [Message]] = [:]
    var userIDName : [(userID: String, userName: String?)]?
    func sortedChatList() -> [(userID: String, chatInfo: ChatInfo)] {
        var sortedArray : [(userID: String, chatInfo: ChatInfo)] = []
        for (key, value) in self.chatList.chats {
            sortedArray.append((userID: key, chatInfo: value))
        }
        sortedArray.sort(by: {
            if let date0 = $0.chatInfo.date, let date1 = $1.chatInfo.date {
                return date0 > date1
            } else {
                if ($0.chatInfo.date != nil) {
                    return true
                }
                if ($1.chatInfo.date != nil) {
                    return false
                }
            }
            if let name0 = $0.chatInfo.name, let name1 = $1.chatInfo.name {
                return name0.first! > name1.first!
            }
            return false
        })

        return sortedArray
    }
}
