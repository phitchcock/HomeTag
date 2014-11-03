//
//  WebViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 10/31/14.
//  Copyright (c) 2014 Peter Hitchcock. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, NSXMLParserDelegate {

    var post:Post!
    var home:Home!
    var address: String = String()
    var eName: String = String()

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var outputLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = NSURL(string: "http://www.zillow.com/webservice/GetZestimate.htm?zws-id=X1-ZWz1dovjvxhiiz_4ixyf&zpid=48749425") {
            var xmlParser = NSXMLParser(contentsOfURL: url)
            xmlParser?.delegate = self
            xmlParser?.parse()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: NSDictionary!) {
        println("Element's name is \(elementName)")
        //println("Element's attributes are \(attributeDict)")

        eName = elementName
        if elementName == "address" {
            address = String()
        }


    }

    func parser(parser: NSXMLParser!, foundCharacters string: String!) {

    }

    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        if elementName == "address" {
            post.address = address
            //outputLabel.text = post.address
        }
    }
    

}
