//
//  messageCellView.swift
//  TinkoffChat
//
//  Created by Анна Лихтарова on 10.03.2018.
//  Copyright © 2018 Анна Лихтарова. All rights reserved.
//

import UIKit

class MessageCellView: UITableViewCell, MessageCellConfiguration {
    var messageText : String?
    var isIncoming : Bool?
    
    @IBOutlet var incomingMessageLabel: UILabel!
    
    @IBOutlet var outcomingMessageLabel: UILabel!
    func configure(withText messageText: String?, withIsIncoming isIncoming: Bool?){
        
        self.messageText = messageText
        self.isIncoming = isIncoming
        
        guard let isIncoming = isIncoming else {
            incomingMessageLabel = nil
            outcomingMessageLabel = nil
            return
        }
        let messageTextUnwrapped = messageText ?? ""
        if (isIncoming) {
            showIncomingMessage(text: messageTextUnwrapped)
        } else {
            showOutcomingMessage(text: messageTextUnwrapped)
        }
    }
    
    func showOutcomingMessage(text: String) {
        
        outcomingMessageLabel.textColor = .white
        outcomingMessageLabel.text = text
        outcomingMessageLabel.preferredMaxLayoutWidth = self.bounds.width * 0.75 - 30 - 13
        
        let bubbleView = MessageShapeView()
        bubbleView.backgroundColor = .clear
        
        self.addSubview(bubbleView)
        self.sendSubview(toBack: bubbleView)
        
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.topAnchor.constraint(equalTo: outcomingMessageLabel.topAnchor, constant: -6).isActive = true
        bubbleView.bottomAnchor.constraint(equalTo: outcomingMessageLabel.bottomAnchor, constant: 6).isActive = true
        bubbleView.leftAnchor.constraint(equalTo: outcomingMessageLabel.leftAnchor, constant: -13).isActive = true
        bubbleView.rightAnchor.constraint(equalTo: outcomingMessageLabel.rightAnchor, constant: 17).isActive = true
    }
    
    func showIncomingMessage(text: String) {
        
        incomingMessageLabel.textColor = .black
        incomingMessageLabel.text = text
        incomingMessageLabel.preferredMaxLayoutWidth = self.bounds.width * 0.75 - 30 - 13
        
        let bubbleView = MessageShapeView()
        bubbleView.isIncoming = true
        bubbleView.backgroundColor = .clear
        
        self.addSubview(bubbleView)
        self.sendSubview(toBack: bubbleView)
        
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.topAnchor.constraint(equalTo: incomingMessageLabel.topAnchor, constant: -6).isActive = true
        bubbleView.bottomAnchor.constraint(equalTo: incomingMessageLabel.bottomAnchor, constant: 6).isActive = true
        bubbleView.leftAnchor.constraint(equalTo: incomingMessageLabel.leftAnchor, constant: -25).isActive = true
        bubbleView.rightAnchor.constraint(equalTo: incomingMessageLabel.rightAnchor, constant: 13).isActive = true
    }
    /*override func awakeFromNib() {
     super.awakeFromNib()
     // Initialization code
     }
     
     override func setSelected(_ selected: Bool, animated: Bool) {
     super.setSelected(selected, animated: animated)
     
     // Configure the view for the selected state
     }*/
    
}
protocol MessageCellConfiguration : class {
    var messageText : String? {get set}
    var isIncoming : Bool? {get set}
}
