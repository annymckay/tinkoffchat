//
//  conversationCellView.swift
//  TinkoffChat
//
//  Created by Анна Лихтарова on 10.03.2018.
//  Copyright © 2018 Анна Лихтарова. All rights reserved.
//

import UIKit

class ConversationCellView: UITableViewCell, ConversationCellConfiguration {
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var messageLabel: UILabel!
    
    @IBOutlet var dateLabel: UILabel!
    
    var name: String?
    var message: String?
    var date: Date?
    var online: Bool?
    var hasUnreadMessages: Bool?
    var userID : String?
    
    
    
    func configure(withUserID userID: String, withName name: String?, withMessage message : String?, withDate date : Date?, withOnline online : Bool?, withHasUnreadMessages hasUnreadMessages : Bool?) {
        
        self.userID = userID
        self.name = name
        self.message = message
        self.date = date
        self.online = online
        self.hasUnreadMessages = hasUnreadMessages
        
        
        let nameUnwrapped = name ?? "..."
        nameLabel.text = nameUnwrapped
        
        let hasUnreadMessagesUnwrapped = hasUnreadMessages ?? false
        if hasUnreadMessagesUnwrapped {
            messageLabel.font = UIFont.boldSystemFont(ofSize: messageLabel.font.pointSize)
        }
        
        if let message = message {
            messageLabel.text = message
        } else {
            messageLabel.text = "No messages yet"
            messageLabel.font = UIFont.italicSystemFont(ofSize: messageLabel.font.pointSize - 5)
        }
        
        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd"
            if dateFormatter.string(from: Date.init()) == dateFormatter.string(from: date) {
                dateFormatter.dateFormat = "HH:mm"
            } else {
                dateFormatter.dateFormat = "dd MMM"
            }
            dateLabel.text = dateFormatter.string(from: date)
        } else {
            dateLabel.text = "  "
        }
        
        let onlineUnwrapped = online ?? false
        if onlineUnwrapped {
            self.backgroundColor = UIColor.init(red: 254.0/255, green: 255.0/255, blue: 232.0/255, alpha: 1)
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundColor = UIColor.white
        messageLabel.font = UIFont.systemFont(ofSize: 22)        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}




protocol ConversationCellConfiguration : class {
    var name : String? {get set}
    var message : String? {get set}
    var date : Date? {get set}
    var online : Bool? {get set}
    var hasUnreadMessages : Bool? {get set}
    
}
