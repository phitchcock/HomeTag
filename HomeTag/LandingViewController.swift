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

    override func viewDidLoad() {
        super.viewDidLoad()
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
