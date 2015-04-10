//
//  LoginViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 4/10/15.
//  Copyright (c) 2015 Peter Hitchcock. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        view.endEditing(true)
    }

    @IBAction func signinAction(sender: UIButton) {
        println("button")
        PFUser.logInWithUsernameInBackground(usernameTextField.text, password: passwordTextField.text) {
            (user: PFUser!, error: NSError!) -> Void in
            if user != nil {
                // Do stuff after successful login.
                self.performSegueWithIdentifier("loginSegue", sender: self)
                println("what")
            } else {
                // The login failed. Check error to see why.
            }
        }
    }
}
