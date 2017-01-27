//
//  TweetTableViewCell.swift
//  SmashTag
//
//  Created by Wilko Zonnenberg on 25-11-16.
//  Copyright © 2016 Wilko Zonnenberg. All rights reserved.
//

import UIKit
import Kingfisher

class TweetTableViewCell: UITableViewCell {
    
    var tweet: Tweet? {
        didSet{
            updateUI()
        }
    }
    
    @IBOutlet weak var tweetCreatedLabel: UILabel!

    @IBOutlet weak var tweetProfileImageView: UIImageView!
    
    @IBOutlet weak var tweetScreenNameLabel: UILabel!

    @IBOutlet weak var tweetTextLabel: UILabel!
    
    
    let hashTagMentionColor = UIColor.purple
    let urlMentionColor = UIColor(red: 0.0/255.0, green: 191.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    let userMentionColor = UIColor.blue
    
    
    func colorMention(attributedString: NSMutableAttributedString, color: UIColor, mentionKeyword: String){
        var range = NSRange(location: 0, length: attributedString.length)
        
        while (range.location != NSNotFound) {
                range = (attributedString.string as NSString).range(of: mentionKeyword, options: [], range: range)
            if (range.location != NSNotFound) {
                attributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSRange(location: range.location, length: mentionKeyword.characters.count))
                range = NSRange(location: range.location + range.length, length: attributedString.length - (range.location + range.length))
            }
        }
    }

    func updateUI() {
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        
        if let tweet = self.tweet{
            let attributedString = NSMutableAttributedString(string: tweet.text)
            for _ in tweet.media {
                attributedString.append(NSMutableAttributedString(string:" 📷"))
            }
            for userMention in tweet.userMentions{
                colorMention(attributedString: attributedString, color: userMentionColor, mentionKeyword: userMention.keyword)
            }
            for hashTagMention in tweet.hashtags {
                colorMention(attributedString: attributedString, color: hashTagMentionColor, mentionKeyword: hashTagMention.keyword)
            }
            for urlMention in tweet.urls {
                colorMention(attributedString: attributedString, color: urlMentionColor, mentionKeyword: urlMention.keyword)
            }
                
            tweetTextLabel?.attributedText = attributedString
        
            tweetScreenNameLabel?.text = "\(tweet.user)"
            if let profileImageURL = tweet.user.profileImageURL{
                tweetProfileImageView?.kf.setImage(with: profileImageURL)
                
            }
            
            let formatter = DateFormatter()
            if NSDate().timeIntervalSince(tweet.created) > 24*60*60 {
                formatter.dateStyle = DateFormatter.Style.short
            } else {
                formatter.timeStyle = DateFormatter.Style.short
            }
            tweetCreatedLabel?.text = formatter.string(from: tweet.created)
        }
        
    }
    
    
}
