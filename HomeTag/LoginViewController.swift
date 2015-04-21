//
//  LoginViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 4/10/15.
//  Copyright (c) 2015 Peter Hitchcock. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var fbButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        //usernameTextField.becomeFirstResponder()

        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.lightGrayColor().CGColor

        fbButton.layer.cornerRadius = 5
        fbButton.layer.borderWidth = 1
        fbButton.layer.borderColor = UIColor.lightGrayColor().CGColor

        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
    }

    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() != nil {
            performSegueWithIdentifier("loginSegue", sender: self)
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
            usernameTextField.resignFirstResponder()
        }
        else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            login()
        }

        return true
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view.endEditing(true)
    }
    
    @IBAction func fbLogin(sender: UIButton) {
        let permissions = ["public_profile"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier("loginSegue", sender: self)
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier("loginSegue", sender: self)
                    }
                }
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        })

    }

    @IBAction func signinAction(sender: AnyObject) {
        login()
    }

    func login() {
        var config: SwiftLoader.Config = SwiftLoader.Config()
        config.size = 100
        config.spinnerColor = UIColor(red: 49/255, green: 196/255, blue: 255/255, alpha: 1.0)
        config.backgroundColor = UIColor.whiteColor()
        config.titleTextColor = UIColor.blackColor()
        config.spinnerLineWidth = 1

        SwiftLoader.setConfig(config)
        SwiftLoader.show(title: "Logging In...", animated: true)

        PFUser.logInWithUsernameInBackground(usernameTextField.text, password: passwordTextField.text) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                SwiftLoader.hide()

                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("loginSegue", sender: self)
                }

            } else {
                SwiftLoader.hide()

                if let message: AnyObject = error!.userInfo!["error"] {
                    RKDropdownAlert.title("ERROR", message: "\(message)".capitalizedString, backgroundColor: UIColor.whiteColor(), textColor: UIColor.blackColor())
                }
            }
        }
    }
}
