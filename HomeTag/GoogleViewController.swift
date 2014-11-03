//
//  GoogleViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 11/3/14.
//  Copyright (c) 2014 Peter Hitchcock. All rights reserved.
//

import UIKit

class GoogleViewController: UIViewController {

    var home:Home!



    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var search = home.streetName
        var fixedSearch = search.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        println(fixedSearch)
        
        if let url = NSURL(string: "http://www.google.com") {
            println(url)
            let request = NSURLRequest(URL: url)
            println(request)
            webView.loadRequest(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
