//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Анна Лихтарова on 10.03.2018.
//  Copyright © 2018 Анна Лихтарова. All rights reserved.
//

import UIKit

class ConversationViewController: UITableViewController {
    
    var humanName : String?
    var defaultMessages = [ "👋",
                            "🖖🏽",
                            "Ку, скинь мне описание UILabel",
                            "UILabel. A view that displays one or more lines of read-only text, often used in conjunction with controls to describe their intended purpose. The appearance of labels is configurable, and they can display attributed strings, allowing you to customize the appearance of substrings within a label. Вот",
                            "Смотри, что еще есть - UITextField. An object that displays an editable text area in your interface. You use text fields to gather text-based input from the user using the onscreen keyboard. The keyboard is configurable for many different types of input such as plain text, emails, numbers, and so on",
                            "Хорошо что есть документация))" ]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
 
        let nameLabel = UILabel()
        nameLabel.text = humanName ?? ""
        navigationItem.titleView = nameLabel
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return defaultMessages.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let incomingCells = [0, 2, 4]
        var identifier = "OutcomingMessageCellView"
        var isIncoming = false
        if (incomingCells.contains(indexPath.row)) {
            identifier = "IncomingMessageCellView"
            isIncoming = true
        }
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MessageCellView {
            dequeuedCell.configure(withText: defaultMessages[indexPath.row], withIsIncoming: isIncoming)
            return dequeuedCell
            
        }
        return UITableViewCell(style: .default, reuseIdentifier: identifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.scrollToRow(at: IndexPath.init(row: 5, section: 0), at: UITableViewScrollPosition.bottom, animated: true)
    }
    
    
}
