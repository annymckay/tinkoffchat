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
        
        //tableView.estimatedRowHeight = 20.0
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //table

        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.scrollToRow(at: IndexPath.init(row: 5, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
