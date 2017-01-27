//
//  TweetImageTableViewCell.swift
//  SmashTag
//
//  Created by Wilko Zonnenberg on 27-11-16.
//  Copyright © 2016 Wilko Zonnenberg. All rights reserved.
//

import UIKit
import Kingfisher

class TweetImageTableViewCell: UITableViewCell, UIScrollViewDelegate {

    @IBOutlet weak var tweetImageView: UIImageView!
    
    @IBOutlet weak var tweetScrollView: UIScrollView!
    
    var imageUrl : URL? {
        didSet{
            updateUI()
        }
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return tweetImageView
    }
    
    func downloadCompleted(image: UIImage){
        self.tweetImageView!.image = image
        self.tweetImageView!.sizeToFit()
    }
    
    func updateUI(){
        tweetImageView.kf.setImage(with: imageUrl, placeholder: UIImage.init(named: "loadinggif.gif"), options: nil, progressBlock: nil, completionHandler: {(image, error, cacheType, imageUrl) in
                self.downloadCompleted(image: image!)
        })
    }
    

}
