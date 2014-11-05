//
//  ShowHomeTableViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 10/31/14.
//  Copyright (c) 2014 Peter Hitchcock. All rights reserved.
//

import UIKit
import CoreData

class ShowHomeTableViewController: UITableViewController {

    var home:Home!


    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var showTableView: UITableView!
    @IBOutlet weak var addressTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = home.streetName
        addressTextField.text = home.streetName
        imageView.image = UIImage(data: home.image)
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func saveAction(sender: AnyObject) {
        saveHome()
    }

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
            //let cell = sender as UITableViewCell
            //let indexPath = tableView.indexPathForCell(cell)
            let destinationViewController = segue.destinationViewController as NotesViewController
            destinationViewController.home = home
        }
        

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



}
