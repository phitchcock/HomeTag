//
//  ProfileViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 4/10/15.
//  Copyright (c) 2015 Peter Hitchcock. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var centerImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        centerImageView.layer.borderWidth = 1
        centerImageView.clipsToBounds = true
        centerImageView.layer.borderColor = UIColor.whiteColor().CGColor
        centerImageView.layer.cornerRadius = centerImageView.frame.size.height / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
