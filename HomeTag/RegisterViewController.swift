//
//  RegisterViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 4/10/15.
//  Copyright (c) 2015 Peter Hitchcock. All rights reserved.
//

import UIKit
import Parse

class RegisterViewController: UIViewController {

    var user = PFUser()
    var config: SwiftLoader.Config = SwiftLoader.Config()

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var fbButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        signupButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        signupButton.layer.borderWidth = 1
        signupButton.layer.cornerRadius = 5

        fbButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        fbButton.layer.borderWidth = 1
        fbButton.layer.cornerRadius = 5

        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
    }

    @IBAction func signUpAction(sender: UIButton) {
        signup()
    }

    @IBAction func fbSignup(sender: UIButton) {
        let permissions = ["public_profile"]

        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, {
            (user: PFUser!, error: NSError!) -> Void in
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                    dispatch_async(dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier("registerSegue", sender: self)
                    }
                } else {
                    println("User logged in through Facebook!")
                    dispatch_async(dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier("registerSegue", sender: self)
                    }
                }
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        })

    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        view.endEditing(true)
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    func signup() {
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        user.email = emailTextField.text.lowercaseString

        config.size = 100
        config.spinnerColor = UIColor(red: 49/255, green: 196/255, blue: 255/255, alpha: 1.0)
        config.backgroundColor = UIColor.whiteColor()
        config.titleTextColor = UIColor.blackColor()
        config.spinnerLineWidth = 1

        SwiftLoader.setConfig(config)
        SwiftLoader.show(title: "Trying to signup...", animated: true)

        user.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            if error == nil {
                SwiftLoader.hide()

                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("registerSegue", sender: self)
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
