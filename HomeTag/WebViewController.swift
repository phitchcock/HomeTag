//
//  WebViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 10/31/14.
//  Copyright (c) 2014 Peter Hitchcock. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate, UISearchBarDelegate {

    // MARK: - Variables
    var home:Home!

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.text = home.streetName
        clickBar()
    }

    override func viewWillAppear(animated: Bool) {
        //screenName = "Zillow"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - searchBarSearchButtonClicked
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        var text = searchBar.text
        var encodeText = text.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())

        if let encodeText = encodeText {
            var url = NSURL(string: "http://www.zillow.com/homes/\(encodeText)_rb")
            var request = NSURLRequest(URL: url!)
            self.webView.loadRequest(request)
        }
    }

    func clickBar() {
        var text = searchBar.text
        var encodeText = text.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())

        if let encodeText = encodeText {
            var url = NSURL(string: "http://www.zillow.com/homes/\(encodeText)_rb")
            var request = NSURLRequest(URL: url!)
            self.webView.loadRequest(request)
        }
    }

    // MARK: - WebView
    @IBAction func backButtonPressed(sender: AnyObject) {
        webView.goBack()
    }

    @IBAction func goForwardButtonPressed(sender: AnyObject) {
        webView.goForward()
    }

    @IBAction func refreshButtonPressed(sender: AnyObject) {
        webView.reload()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        print("Webview fail with error \(error)");
    }

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }

    func webViewDidStartLoad(webView: UIWebView) {
        print("Webview started Loading")
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        print("Webview did finish load")
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
