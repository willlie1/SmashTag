//
//  WebViewController.swift
//  SmashTag
//
//  Created by Wilko Zonnenberg on 28-11-16.
//  Copyright © 2016 Wilko Zonnenberg. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!

    var url : String?{
        didSet{
            refreshWebView()
        }
    }
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    func refreshWebView(){
        if webView != nil {
            let url = URL(string: self.url!)
            let request = URLRequest(url: url!)
            webView.loadRequest(request)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshWebView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        updateButtons();
    }
    
    func updateButtons(){
        if webView.canGoBack {
            backButton.isEnabled = true
        } else {
            backButton.isEnabled = false
        }
        if webView.canGoForward {
            forwardButton.isEnabled = true
        } else {
            forwardButton.isEnabled = false
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if webView.canGoBack {
            webView.goBack()
        }
        updateButtons();
    }


    @IBAction func forwardButtonPressed(_ sender: UIButton) {
        if webView.canGoForward{
            webView.goForward()
        }
        updateButtons();
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
