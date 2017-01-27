//
//  ImageDetailViewController.swift
//  SmashTag
//
//  Created by Wilko Zonnenberg on 28-11-16.
//  Copyright © 2016 Wilko Zonnenberg. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet{
            scrollView.contentSize = imageView.frame.size
        }
    }
    
    private var imageView = UIImageView()
    
    
    var image : UIImage? {
        get{ return imageView.image }
        set{
            imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 1000)
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = "Media"
        scrollView.addSubview(imageView)
        updateZoom()
        // Do any additional setup after loading the view.
    }
    
    func updateZoom (){
        let maxZoom = max(self.view.bounds.size.width / (self.imageView.frame.size.width), (self.view.bounds.size.height - (self.navigationController?.navigationBar.frame.size.height)!) / self.imageView.frame.size.height)

        self.scrollView.zoomScale = maxZoom;
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }


}
