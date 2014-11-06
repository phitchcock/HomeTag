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
    var isFavorite:Bool!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var showTableView: UITableView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var favoriteSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        //title = home.streetName
        buttonState()
        tableView.rowHeight = 44
        addressTextField.text = home.streetName
        imageView.image = UIImage(data: home.image)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
    }

    override func viewDidAppear(animated: Bool) {
        //buttonState()
        addressTextField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - @IBActions
    @IBAction func saveAction(sender: AnyObject) {
        saveHome()
    }

    @IBAction func updateIsVisited(sender: AnyObject) {

        // Yes button clicked
        //let buttonClicked = sender as UIButton
        if favoriteSwitch.on == true {
            isFavorite = true
            //yesButton.hidden = true
            //noButton.hidden = false
            saveFavorite()
            println(home.isFavorite)
        } else if favoriteSwitch.on == false {
            isFavorite = false
            //yesButton.backgroundColor = UIColor.grayColor()
            //noButton.hidden = true
            //yesButton.hidden = false
            saveFavorite()
            println(home.isFavorite)
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

    func saveFavorite() {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {
            if home != nil {
                home.isFavorite = isFavorite
            }

            var e: NSError?
            if managedObjectContext.save(&e) != true {
                println("insert error: \(e!.localizedDescription)")
                return
            }
        }
    }

    func buttonState() {

        if home.isFavorite == true {
            favoriteSwitch.on = true
            //noButton.backgroundColor = UIColor.grayColor()
        }
        else if home.isFavorite == false {
            favoriteSwitch.on = false
            //yesButton.backgroundColor = UIColor.grayColor()
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
