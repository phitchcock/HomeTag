//
//  ShowHomeTableViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 10/31/14.
//  Copyright (c) 2014 Peter Hitchcock. All rights reserved.
//

import UIKit
import CoreData

class ShowHomeTableViewController: UITableViewController, UITextFieldDelegate {

    // MARK: - Variables
    var home:Home!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var showTableView: UITableView!
    @IBOutlet weak var addressTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        //title = home.streetName
        tableView.rowHeight = 44
        addressTextField.text = home.streetName
        imageView.image = UIImage(data: home.image)
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }

    override func viewDidAppear(animated: Bool) {
        addressTextField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - @IBActions
    @IBAction func saveAction(sender: AnyObject) {
        saveHome()
    }

    @IBAction func unwindToShowHome(sender: UIStoryboardSegue) {
        
    }

    func saveHome() {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {
            if home != nil {
                home.streetName = addressTextField.text
            }

            var e: NSError?
            if managedObjectContext.save(&e) != true {
                println("insert error: \(e!.localizedDescription)")
                return
            }
        }
    }

    // MARK: - prepareForSegue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mapSegue" {
            let destinationController = segue.destinationViewController as MapViewController
            destinationController.home = home
        }

        if segue.identifier == "webSegue" {
            let destinationController = segue.destinationViewController as WebViewController
            destinationController.home = home
        }

        if segue.identifier == "googleSegue" {
            let destinationController = segue.destinationViewController as GoogleViewController
            destinationController.home = home
        }

        if segue.identifier == "notesSegue" {
            let destinationViewController = segue.destinationViewController as NotesViewController
            destinationViewController.home = home
        }
    }

    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        view.resignFirstResponder()
    }
}
