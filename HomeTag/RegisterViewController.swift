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


    override func viewDidLoad() {
        super.viewDidLoad()

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
        user.email = emailTextField.text
        // other fields can be set just like with PFObject
        //user["phone"] = "415-392-0202"

        user.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            if error == nil {
                // Hooray! Let them use the app now.
                //prepareForSegue("what", sender: self)
                self.performSegueWithIdentifier("registerSegue", sender: self)
            } else {
                //let errorString = error.userInfo["error"] as String
                // Show the errorString somewhere and let the user try again.
            }
        }
    }

    @IBAction func signUpAction(sender: UIButton) {
        signup()
    }
    

}
