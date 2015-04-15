//
//  LandingViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 4/10/15.
//  Copyright (c) 2015 Peter Hitchcock. All rights reserved.
//

import UIKit
import Parse

class LandingViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        loginButton.layer.borderWidth = 1

        signupButton.layer.cornerRadius = 5
        signupButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        signupButton.layer.borderWidth = 1

        facebookButton.layer.cornerRadius = 5
        facebookButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        facebookButton.layer.borderWidth = 1


    }

    @IBAction func unwind(segue: UIStoryboardSegue) {
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        view.endEditing(true)
    }

}
