//
//  TweetTableViewController.swift
//  SmashTag
//
//  Created by Wilko Zonnenberg on 20-11-16.
//  Copyright © 2016 Wilko Zonnenberg. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController, UITextFieldDelegate {

    var tweets = [[Tweet]]()
    
    @IBOutlet weak var searchTextfield: UITextField! {
        didSet{
            searchTextfield.delegate = self
            searchTextfield.text = searchText
            lastSuccessFulRequest = nil
        }
    }
    
    var searchText: String? = "#Stanford" {
        didSet{
            searchTextfield?.text = searchText
            tweets.removeAll()
            tableView.reloadData()
            self.navigationController?.navigationBar.topItem?.title = searchText!
            refresh()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextfield {
            textField.resignFirstResponder()
            searchText = textField.text
            UserDefaultsHelper.addSearchToSearchHistory(search: searchText!)
        }
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationController?.navigationBar.topItem?.title = searchText!

        refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = searchText!
    }
    
    var lastSuccessFulRequest: TwitterRequest?
    
    var nextRequestToAttempt: TwitterRequest? {
        if lastSuccessFulRequest == nil {
            if searchText != nil{
                return TwitterRequest(search: searchText!, count: 100)
            } else {
                return nil
            }
        } else {
            return TwitterRequest(search: searchText!, count: 100)
        }
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl?) {
        if searchText != nil {
            if let request = nextRequestToAttempt {
                
                request.fetchTweets { (newTweets) in
                    DispatchQueue.main.async {
                        if newTweets.count > 0 {
                            self.lastSuccessFulRequest = request
                            print(" received new tweets")
                            self.tweets.insert(newTweets, at: 0)
                            self.tableView.reloadData()
                            sender?.endRefreshing()
                        } else {
                            print (" not received new tweets")
                            sender?.endRefreshing()
                        }
                        
                    }
                }
            }
        } else {
            sender?.endRefreshing()
        }
    }
    
    
    func refresh() {
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
        refresh(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }

    private struct Storyboard {
        static let CellReuseIdentifier = "Tweet"
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath) as! TweetTableViewCell
        
        cell.tweet = tweets[indexPath.section][indexPath.row]

        return cell
    }


    //     MARK: - Navigation
    //
    //     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier  = segue.identifier{
            switch identifier {
            case "Show tweet detail":
                if let vc = segue.destination as? TweetDetailTableViewController{
                    vc.tweet = (sender as! TweetTableViewCell).tweet
                }
            default:
                break;
            }
        }
        
    }
    
    @IBAction func unwindToTweetTableViewController(segue : UIStoryboardSegue){
        self.navigationController?.navigationBar.topItem?.title = searchText!
        switch segue.identifier! {
        case "UnwindToTweetTableView":
            UserDefaultsHelper.addSearchToSearchHistory(search: searchText!)
            break
        default:
            break
        }
    }

}
