//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Анна Лихтарова on 01.04.2018.
//  Copyright © 2018 Анна Лихтарова. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var creatingMessageView: UIView!
    var model : ConversationsModel?
    var userID : String = ""
    var userName : String?

    var sendMessage : ((String, String, ((Bool, Error?) -> ())?) -> ())?
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        if let text = messageTextField.text {
            if (text == "") {
                return
            }
            self.view.endEditing(true)
            let date = Date.init()
            self.sendMessage!(text, userID, nil)
            if (model!.dialogsHistory[userID] == nil) {
                model!.dialogsHistory[userID] = []
            }
            model!.dialogsHistory[userID]!.append(Message(isIncoming: false, text: text, date: date))
            
            self.model!.chatList.chats[userID]?.message = text
            self.model!.chatList.chats[userID]?.date = date
            
            chatTableView.reloadData()
            chatTableView.scrollToRow(at: IndexPath.init(row:  model!.dialogsHistory[userID]!.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: true)
        }
    }
    func modelChangedCompletion() {
        model!.chatList.chats[userID]?.isUnread = false
        chatTableView.reloadData()
        chatTableView.scrollToRow(at: IndexPath.init(row:  model!.dialogsHistory[userID]!.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: true)
        if (model!.chatList.chats[userID] == nil) {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setDesign()
        sendButton.isEnabled = true
        chatTableView.dataSource = self
        chatTableView.delegate = self
        messageTextField.delegate = self
        self.model!.chatList.chats[userID]?.isUnread = false
        model!.modelChangedCompletion = modelChangedCompletion
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if ( model!.dialogsHistory[userID] != nil) {
            if ( model!.dialogsHistory[userID]!.count > 0) {
                chatTableView.scrollToRow(at: IndexPath.init(row:  model!.dialogsHistory[userID]!.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: true)
            }
        }
    }
    func setDesign() {
        let nameLabel = UILabel()
        nameLabel.text = userName ?? ""
        navigationItem.titleView = nameLabel
        chatTableView.rowHeight = UITableViewAutomaticDimension
        messageTextField.borderStyle = .none
        messageTextField.layer.cornerRadius = 10
        messageTextField.layer.borderWidth = 0.5
        sendButton.layer.cornerRadius = 10
    }

}

extension ConversationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    @objc func keyboardWillAppear(notification: NSNotification) {
        //        if (self.view.frame.origin.y < 0) {
        //            return
        //        }
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                /*self.chatTableView.frame = CGRect(x: self.chatTableView.frame.origin.x,
                 y: self.chatTableView.frame.origin.y,
                 width: self.chatTableView.frame.size.width,
                 height: self.chatTableView.frame.size.height - keyboardSize.height)
                 self.creatingMessageView.frame.origin.y -= keyboardSize.height*/
                UIView.animate(withDuration: 0.5, delay: 0,
                               options: .allowAnimatedContent, animations: {
                                self.view.frame.origin.y -= keyboardSize.height
                                //self.creatingMessageView.frame.origin.y -= keyboardSize.height
                }, completion: nil)
            }
        }
        
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        
        //        if (self.view.frame.origin.y >= 0) {
        //            return
        //        }
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                /*self.chatTableView.frame = CGRect(x: self.chatTableView.frame.origin.x,
                 y: self.chatTableView.frame.origin.y,
                 width: self.chatTableView.frame.size.width,
                 height: self.chatTableView.frame.size.height + keyboardSize.height)
                 self.creatingMessageView.frame.origin.y += keyboardSize.height*/
                UIView.animate(withDuration: 0.5, delay: 0,
                               options: .allowAnimatedContent, animations: {
                                self.view.frame.origin.y += keyboardSize.height
                                //self.creatingMessageView.frame.origin.y += keyboardSize.height
                }, completion: nil)
                
            }
        }
    }
}
extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model!.dialogsHistory[userID]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = model!.dialogsHistory[userID]![indexPath.row]
        var identifier : String
        if (message.isIncoming) {
            identifier = "IncomingMessageCellView"
        } else {
            identifier = "OutcomingMessageCellView"
        }
        if let dequeuedCell = chatTableView.dequeueReusableCell(withIdentifier: identifier) as? MessageCellView {
            dequeuedCell.configure(withText: message.text, withIsIncoming: message.isIncoming)
            return dequeuedCell
            
        }
        return UITableViewCell(style: .default, reuseIdentifier: identifier)
    }
}

