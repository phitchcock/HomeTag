//
//  ShowHomeTableViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 10/31/14.
//  Copyright (c) 2014 Peter Hitchcock. All rights reserved.
//

import UIKit
import CoreData

class ShowHomeTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Variables
    var home:Home!
    var isFavorite:Bool!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var showTableView: UITableView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var favoriteSwitch: UISwitch!
    @IBOutlet weak var updateButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        //title = home.streetName
        buttonState()
        tableView.rowHeight = 44
        addressTextField.text = home.streetName
        imageView.image = UIImage(data: home.image)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        addressTextField.delegate = self
        updateButton.title = ""
        updateButton.enabled = false
        updateButton.tintColor = UIColor(red: 0.263, green: 0.596, blue: 0.847, alpha: 0.10)

        
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
        saveImage()
        addressTextField.endEditing(true)
        updateButton.title = ""
        updateButton.enabled = false
        updateButton.tintColor = UIColor(red: 0.263, green: 0.596, blue: 0.847, alpha: 0.10)
        
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

    func saveImage() {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {
            if home != nil {
                home.image = UIImagePNGRepresentation(imageView.image)
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

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .Camera
                imagePicker.delegate = self

                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .PhotoLibrary
                imagePicker.delegate = self

                self.presentViewController(imagePicker, animated: true, completion: nil)
            }

        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }


    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imageView.image = image
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true

        dismissViewControllerAnimated(true, completion: nil)
        setSaveButton()
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

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        addressTextField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        updateButton.tintColor = UIColor.whiteColor()
        updateButton.enabled = true
        updateButton.title = "Done"
    }

    func setSaveButton() {
        updateButton.tintColor = UIColor.whiteColor()
        updateButton.enabled = true
        updateButton.title = "Save"
    }
}
