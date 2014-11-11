//
//  ShowHomeTableViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 10/31/14.
//  Copyright (c) 2014 Peter Hitchcock. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class ShowHomeTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {

    // MARK: - Variables
    var home:Home!
    var isFavorite:Bool!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var showTableView: UITableView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var favoriteSwitch: UISwitch!
    @IBOutlet weak var updateButton: UIBarButtonItem!
    @IBOutlet weak var tagTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        //title = home.streetName
        buttonState()
        tableView.rowHeight = 44
        addressTextField.text = home.streetName
        tagTextField.text = home.tag
        imageView.image = UIImage(data: home.image)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        addressTextField.delegate = self
        tagTextField.delegate = self
        updateButton.title = ""
        updateButton.enabled = false
        updateButton.tintColor = UIColor(red: 0.263, green: 0.596, blue: 0.847, alpha: 0.10)

        
    }

    override func viewDidAppear(animated: Bool) {
        //buttonState()
        addressTextField.resignFirstResponder()
        tagTextField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - @IBActions
    @IBAction func saveAction(sender: AnyObject) {
        saveHome()
        saveImage()
        saveTag()
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

    @IBAction func sendEmail(sender: AnyObject) {
        if MFMailComposeViewController.canSendMail() {
            var composer = MFMailComposeViewController()
            composer.mailComposeDelegate = self
            composer.navigationBar.tintColor = UIColor.whiteColor()
            composer.setSubject("Check Out this Home!")

            var text = addressTextField.text
            var encodeText = text.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())


            var htmlMsg = "<html><body><p>\(home.streetName)</p><p><a href="  + "http://www.zillow.com/homes/" + encodeText! + "_rb" + ">Zillow Link</a></p><a <p><a href="  + "http://www.google.com/search?q=" + encodeText! + ">Google Link</a></p></body><html>"
            composer.setMessageBody(htmlMsg, isHTML: true)

            //var image = UIImage(data: home.image)
            //var imageData = UIImagePNGRepresentation(image)
            //composer.addAttachmentData(image, mimeType: "image/png", fileName: "home.png")


            presentViewController(composer, animated: true, completion: nil)
        }
    }

    @IBAction func sendSMS(sender: AnyObject) {
        if MFMessageComposeViewController.canSendText() {
            var composer = MFMessageComposeViewController()
            var text = addressTextField.text
            var encodeText = text.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
            composer.messageComposeDelegate = self
            composer.navigationBar.tintColor = UIColor.whiteColor()
            //composer.subject = "Checkout this Home!"
            composer.body = "Check out this home!\n \nMap: \(home.streetName) \n \nZillow http://www.zillow.com/homes/" + encodeText! + "_rb"

            //var text = addressTextField.text
            //var encodeText = text.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())


            //var htmlMsg = "<html><body><p>\(home.streetName)</p><p><a href="  + "http://www.zillow.com/homes/" + encodeText! + "_rb" + ">Zillow Link</a></p><a <p><a href="  + "http://www.google.com/search?q=" + encodeText! + ">Google Link</a></p></body><html>"
            //composer.setMessageBody(htmlMsg, isHTML: true)

            //var image = UIImage(data: home.image)
            //var imageData = UIImagePNGRepresentation(image)
            //composer.addAttachmentData(image, mimeType: "image/png", fileName: "home.png")


            presentViewController(composer, animated: true, completion: nil)
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
                home.image = UIImageJPEGRepresentation(imageView.image, 1.0)
                home.thumbNail = UIImageJPEGRepresentation(imageView.image, 0.1)
            }

            var e: NSError?
            if managedObjectContext.save(&e) != true {
                println("insert error: \(e!.localizedDescription)")
                return
            }
        }
    }

    func saveTag() {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {
            if home != nil {
                home.tag = tagTextField.text
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
            selectImage()
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

        if segue.identifier == "imageSegue" {
            let destinationViewController = segue.destinationViewController as ImagesCollectionViewController
            destinationViewController.home = home
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        addressTextField.resignFirstResponder()
        tagTextField.resignFirstResponder()
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

    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        switch result.value {
        case MFMailComposeResultCancelled.value:
            println("Mail Cancelled")
        case MFMailComposeResultSaved.value:
            println("Mail Saved")
        case MFMailComposeResultSent.value:
            println("Mail Sent")
        case MFMailComposeResultFailed.value:
            println("Failed to send mail")
        default:
            break
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        switch result.value {
        case MessageComposeResultCancelled.value:
            println("SMS Cancelled")
        case MessageComposeResultFailed.value:
            println("SMS Failed")
        case MessageComposeResultSent.value:
            break
        default:
            break
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    func selectImage() {
        let shareMenu = UIAlertController(title: nil, message: "Take Picture", preferredStyle: .ActionSheet)
        let cameraAction = UIAlertAction(title: "Take Picture", style: .Default, handler: { (action:UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .Camera
                imagePicker.delegate = self

                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        })
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .Default, handler: { (action:UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .PhotoLibrary
                imagePicker.delegate = self

                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        })


        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)

        //shareMenu.addAction(isFavoriteAction)
        shareMenu.addAction(cameraAction)
        shareMenu.addAction(photoLibraryAction)
        shareMenu.addAction(cancelAction)

        self.presentViewController(shareMenu, animated: true, completion: nil)

    }


}
