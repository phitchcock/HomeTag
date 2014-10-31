//
//  AddHomeTableViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 10/31/14.
//  Copyright (c) 2014 Peter Hitchcock. All rights reserved.
//

import UIKit
import CoreData

class AddHomeTableViewController: UITableViewController {

    var home:Home!

    @IBOutlet weak var streetNameTextField: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func saveHome() {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {
            home = NSEntityDescription.insertNewObjectForEntityForName("Home", inManagedObjectContext: managedObjectContext) as Home
            home.streetName = streetNameTextField.text

            var e: NSError?
            if managedObjectContext.save(&e) != true {
                println("insert error: \(e!.localizedDescription)")
                return
            }
        }

    }

    @IBAction func addHome(sender: AnyObject) {
        saveHome()
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func cancelAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
