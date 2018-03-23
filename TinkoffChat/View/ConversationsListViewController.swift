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

    func getDefaultChat(at index : Int) -> [Any?] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        let messageDateString = "3 MAR"
        let messageDate = dateFormatter.date(from: messageDateString)
        var chat = defaultChats[index]
        if let date = defaultChats[index][2] as? Bool {
            if date {
                chat[2] = Date.init()
            } else {
                chat[2] = messageDate!
            }
        }
        return chat
    }
    var defaultChats = [ ["Tim Cook", "unread; today's date", true, true],
                         ["Bill Gates", "unread; not today's date", false, true],
                         ["Anny Mckay", nil, true, true],
                         ["Санёк", nil, true, true],
                         ["Tom Hiddleston", "unread; not today's date", false, true],
                         ["Teylor Swift", "read; no date", nil, false],
                         [nil, "no name; unread; today's date", true, true],
                         ["Петров", "hasUnreadMessages: nil", false, nil],
                         ["Victor Parker", "Какое-то очень длинное сообщение, которое обрывается в какой-то момент", false, true],
                         ["Some Guy", nil, false, true],]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        profileButton.image = UIImage(named: "placeholder-user50x50")?.withRenderingMode(.alwaysOriginal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return defaultChats.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "ConversationCellView"

        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ConversationCellView {
            let onlineStatus : Bool
            if indexPath.section == 0 {
                onlineStatus = true
            } else {
                onlineStatus = false
            }
            var defaultChat = getDefaultChat(at: indexPath.row)
            dequeuedCell.configure(withName: defaultChat[0] as? String, withMessage: defaultChat[1] as? String, withDate: defaultChat[2] as? Date, withOnline: onlineStatus, withHasUnreadMessages: defaultChat[3] as? Bool)

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
                    conversationViewController.humanName = sourceCell.name ?? ""
                }
            } else if let navigationController =  segue.destination as? UINavigationController,
                      let themesViewController =  navigationController.topViewController as? ThemesViewController {
                themesViewController.delegate = self
            } else if let navigationController =  segue.destination as? UINavigationController,
                      let themesViewControllerSwift = navigationController.topViewController as? ThemesViewControllerSwift {
                themesViewControllerSwift.closure = logThemeChanging
        }
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
