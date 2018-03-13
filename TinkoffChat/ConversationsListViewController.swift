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
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
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
    
    /*override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let destinationViewController = segue.destination as? ConversationViewController {
                if let sourceCell = sender as? ConversationCellView {
                    destinationViewController.humanName = sourceCell.name ?? ""
                }
            }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
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


}
