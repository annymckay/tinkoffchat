//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Анна Лихтарова on 10.03.2018.
//  Copyright © 2018 Анна Лихтарова. All rights reserved.
//

import UIKit

class ConversationsListViewController: UITableViewController {
    
    @IBOutlet var profileButton: UIBarButtonItem!
    
    var dialogsHistory : [String : [Message]]?
    var theme : Theme = Theme()
    var multipeerCommunicator : MultipeerCommunicator?
    var model : ConversationsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.model = ConversationsModel()
        self.multipeerCommunicator = MultipeerCommunicator()
        self.multipeerCommunicator!.model = self.model
        self.model!.modelChangedCompletion = self.tableView.reloadData
        dialogsHistory = [:]
        tableView.dataSource = self
        loadTheme()
        setTheme()
        profileButton.image = UIImage(named: "placeholder-user50x50")?.withRenderingMode(.alwaysOriginal)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.model!.modelChangedCompletion = self.tableView.reloadData
        self.tableView.reloadData()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return model!.chatList.onlineCount
        } else {
            return model!.chatList.offlineCount
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("updating cell \(indexPath.row)")
        let identifier = "ConversationCellView"
        
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ConversationCellView {

            let chatList = model!.sortedChatList()[indexPath.row]

            dequeuedCell.configure(withUserID: chatList.userID, withName: chatList.chatInfo.name, withMessage: chatList.chatInfo.message, withDate: chatList.chatInfo.date, withOnline: chatList.chatInfo.isOnline, withHasUnreadMessages: chatList.chatInfo.isUnread)
            
            return dequeuedCell
            
        }
        return UITableViewCell(style: .default, reuseIdentifier: identifier)
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Online"
        case 1:
            return "History"
        default:
            return ""
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let conversationViewController = segue.destination as? ConversationViewController {
            if let sourceCell = sender as? ConversationCellView {
                let userID = sourceCell.userID!
                conversationViewController.model = self.model
                conversationViewController.userID = userID
                conversationViewController.sendMessage = self.multipeerCommunicator?.sendMessage(string:to:completionHandler:)
                conversationViewController.userName = sourceCell.name ?? ""
            }
        } else if let navigationController =  segue.destination as? UINavigationController,
            let themesViewController =  navigationController.topViewController as? ThemesViewController {
            themesViewController.delegate = self
        } else if let navigationController =  segue.destination as? UINavigationController,
            let themesViewControllerSwift = navigationController.topViewController as? ThemesViewControllerSwift {
            themesViewControllerSwift.theme = self.theme
            themesViewControllerSwift.closure = logThemeChangingSwift
        } else if let navigationController =  segue.destination as? UINavigationController,
            let profileViewController = navigationController.topViewController as? ProfileViewController {
            profileViewController.theme = self.theme
            
        }
    }

    func setTheme() {
        navigationController?.navigationBar.barTintColor = self.theme.barTintColor
        navigationController?.navigationBar.tintColor = self.theme.tintColor
    }
    func loadTheme() {
        let themes = ThemesSwift()
        let gcdDataManager = GCDDataManager()
        gcdDataManager.loadTheme { tag, _ in
            if let tag = tag {
                if let themes = themes.getThemeByTag(tag: tag) {
                self.theme = themes
                self.setTheme()
                }
            }
        }
    }

    func logThemeChangingSwift(selectedTheme: Theme) {
        print(selectedTheme)
        self.theme = selectedTheme
        setTheme()
    }
    func logThemeChanging(selectedTheme: UIColor) {
        print(selectedTheme)
    }

    
    
}

extension ConversationsListViewController: ThemesViewControllerDelegate {
    func themesViewController(_ controller: ThemesViewController!, didSelectTheme selectedTheme: UIColor!) {
        logThemeChanging(selectedTheme: selectedTheme)
        
    }
}
