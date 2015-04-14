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

        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        view.endEditing(true)
    }

    @IBAction func signinAction(sender: AnyObject) {
        var config: SwiftLoader.Config = SwiftLoader.Config()
        config.size = 150
        config.spinnerColor = UIColor(red: 49/255, green: 196/255, blue: 255/255, alpha: 1.0)
        config.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.60)
        config.titleTextColor = UIColor(red: 49/255, green: 196/255, blue: 255/255, alpha: 1.0)
        config.spinnerLineWidth = 1

        SwiftLoader.setConfig(config)
        SwiftLoader.show(title: "Trying to login...", animated: true)

        PFUser.logInWithUsernameInBackground(usernameTextField.text, password: passwordTextField.text) {
            (user: PFUser!, error: NSError!) -> Void in
            if user != nil {
                SwiftLoader.hide()
                // Do stuff after successful login.
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("loginSegue", sender: self)
                }

            } else {
                SwiftLoader.hide()

                if let message: AnyObject = error!.userInfo!["error"] {
                    RKDropdownAlert.title("ERROR", message: "\(message)".capitalizedString, backgroundColor: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.60), textColor: UIColor(red: 49/255, green: 196/255, blue: 255/255, alpha: 1.0))
                }
            }
        }
    }
}
