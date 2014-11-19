//
//  PageContentViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 11/19/14.
//  Copyright (c) 2014 Peter Hitchcock. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {

    var index : Int = 0
    var heading : String = ""
    var imageFile : String = ""
    var subHeading : String = ""

    @IBOutlet weak var headingLabel:UILabel!
    @IBOutlet weak var subHeadingLabel:UILabel!
    @IBOutlet weak var contentImageView:UIImageView!
    @IBOutlet weak var getStartedButton:UIButton!
    @IBOutlet weak var forwardButton:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        headingLabel.text = heading
        subHeadingLabel.text = subHeading
        contentImageView.image = UIImage(named: imageFile)

        getStartedButton.hidden = (index == 2) ? false : true
        forwardButton.hidden = (index == 2) ? true: false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func close(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "hasViewedWalkthrough")
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func nextScreen(sender: AnyObject) {
        let pageViewController = self.parentViewController as PageViewController
        pageViewController.forward(index)
    }
    
}
