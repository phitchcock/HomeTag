//
//  AddHomeTableViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 10/31/14.
//  Copyright (c) 2014 Peter Hitchcock. All rights reserved.
//

import UIKit
import CoreData

class AddHomeTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var home:Home!

    @IBOutlet weak var streetNameTextField: UITextField!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        //UINavigationBar.appearance().barTintColor = UIColor(red: 0.302, green: 0.38, blue: 0.443, alpha: 0.25)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func saveHome() {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {
            home = NSEntityDescription.insertNewObjectForEntityForName("Home", inManagedObjectContext: managedObjectContext) as Home
            home.streetName = streetNameTextField.text
            home.image = UIImagePNGRepresentation(homeImageView.image)
            home.note = textView.text

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

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
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
        homeImageView.image = image
        homeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        homeImageView.clipsToBounds = true

        dismissViewControllerAnimated(true, completion: nil)
    }
}
