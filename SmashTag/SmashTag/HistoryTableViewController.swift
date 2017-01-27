//
//  HistoryTableViewController.swift
//  SmashTag
//
//  Created by Wilko Zonnenberg on 29-11-16.
//  Copyright © 2016 Wilko Zonnenberg. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    var searchHistory: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        searchHistory = UserDefaultsHelper.searchHistory
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistory.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        cell.textLabel?.text = searchHistory[searchHistory.count-1 - indexPath.row]
        return cell
    }
    

    
    // Override to suppor conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            searchHistory.remove(at: searchHistory.count-1 - indexPath.row)
            UserDefaultsHelper.searchHistory = searchHistory
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
 

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier  = segue.identifier{
            switch identifier {
            case "UnwindToTweetTableViewFromHistory":
                if let vc = segue.destination as? TweetTableViewController{
                    vc.searchText = searchText
                }
            default:
                print("Segue not prepared")
                break;
            }
        }
        
    }
    
    var searchText : String?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        searchText = cell?.textLabel?.text
        performSegue(withIdentifier: "UnwindToTweetTableViewFromHistory", sender: self)
    }

}
