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

    @IBOutlet weak var streetAddressLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = home.streetName
        streetAddressLabel.text = home.streetName
        imageView.image = UIImage(data: home.image)
        //textView.text = home.note
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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


}
