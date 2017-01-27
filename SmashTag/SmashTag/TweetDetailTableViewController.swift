//
//  TweetDetailTableViewController.swift
//  SmashTag
//
//  Created by Wilko Zonnenberg on 27-11-16.
//  Copyright © 2016 Wilko Zonnenberg. All rights reserved.
//

import UIKit

class TweetDetailTableViewController: UITableViewController {

    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Details"

        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "Details"

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return calculateNumberOfSections()
    }
    
    func calculateNumberOfSections() -> Int{
        var sections = 0
        if ((tweet?.media) != nil), (tweet?.media.count)! > 0 {
            mediaSection = sections
            sections += 1
        } else {
            mediaSection = 100
        }
        if ((tweet?.userMentions) != nil), (tweet?.userMentions.count)! > 0 {
            userSection = sections
            sections += 1
        } else {
            userSection = 100
        }
        if ((tweet?.urls) != nil), (tweet?.urls.count)! > 0 {
            urlSection = sections
            sections += 1
        } else {
            urlSection = 100
        }
        if ((tweet?.hashtags) != nil), (tweet?.hashtags.count)! > 0 {
            hashtagSection = sections
            sections += 1
        } else {
            hashtagSection = 100
        }
        return sections
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case mediaSection:
                return "Media"
            case userSection:
                return "Mentioned Users"
            case urlSection:
                return "Urls"
            case hashtagSection:
                return "Hashtags"
            default:
                return ""
        }
    }
    
    var mediaSection = 100
    var userSection = 100
    var urlSection = 100
    var hashtagSection = 100

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
            case mediaSection:
                return (tweet?.media.count)!
            case userSection:
                return (tweet?.userMentions.count)!
            case urlSection:
                return (tweet?.urls.count)!
            case hashtagSection:
                return (tweet?.hashtags.count)!
            default:
                return 0
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case mediaSection:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TweetImage", for: indexPath) as! TweetImageTableViewCell
                let media = tweet?.media[indexPath.row]
                cell.imageUrl = media?.url
                return cell
            
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TweetMention", for: indexPath)
                switch indexPath.section {
                    case userSection:
                        cell.textLabel?.text = tweet?.userMentions[indexPath.row].keyword
                        break
                    case urlSection:
                        cell.textLabel?.text = tweet?.urls[indexPath.row].keyword
                        break
                    case hashtagSection:
                        cell.textLabel?.text = tweet?.hashtags[indexPath.row].keyword
                        break
                default:
                        break
                    
                }
                return cell
            }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier  = segue.identifier{
            switch identifier {
            case "Show Image":
                if let vc = segue.destination as? ImageDetailViewController{
                    if let gesture = sender as? UITapGestureRecognizer{
                        vc.image = (gesture.view as? UIImageView)?.image
                    }
                }
            case "UnwindToTweetTableView":
                if let vc = segue.destination as? TweetTableViewController{
                    vc.searchText = searchText
                }
            default:
                break;
            }
        }
        
    }

    var searchText : String?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case urlSection:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            vc.url = tableView.cellForRow(at: indexPath)?.textLabel?.text
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            let cell = tableView.cellForRow(at: indexPath)
            searchText = cell?.textLabel?.text
            performSegue(withIdentifier: "UnwindToTweetTableView", sender: self)
            break

        }
    }
    
 

}
