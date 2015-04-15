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

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()

        signupButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        signupButton.layer.borderWidth = 1
        signupButton.layer.cornerRadius = 5

        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        view.endEditing(true)
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    func signup() {
        var user = PFUser()
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        user.email = emailTextField.text.lowercaseString
        // other fields can be set just like with PFObject
        //user["phone"] = "415-392-0202"

        var config: SwiftLoader.Config = SwiftLoader.Config()
        config.size = 100
        config.spinnerColor = UIColor(red: 49/255, green: 196/255, blue: 255/255, alpha: 1.0)
        config.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        config.titleTextColor = UIColor(red: 49/255, green: 196/255, blue: 255/255, alpha: 1.0)
        config.spinnerLineWidth = 1

        SwiftLoader.setConfig(config)
        SwiftLoader.show(title: "Trying to signup...", animated: true)

        user.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            if error == nil {
                SwiftLoader.hide()
                // Hooray! Let them use the app now.
                //prepareForSegue("what", sender: self)
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("registerSegue", sender: self)
                }

            } else {
                SwiftLoader.hide()
                //let errorString = error.userInfo[""] as String
                if let message: AnyObject = error!.userInfo!["error"] {
                    RKDropdownAlert.title("ERROR", message: "\(message)".capitalizedString, backgroundColor: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0), textColor: UIColor(red: 49/255, green: 196/255, blue: 255/255, alpha: 1.0))
                }
            }
        }
    }

    @IBAction func signUpAction(sender: UIButton) {
        signup()
    }
    

}
