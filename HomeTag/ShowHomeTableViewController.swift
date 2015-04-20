//
//  ShowHomeTableViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 11/14/14.
//  Copyright (c) 2014 Peter Hitchcock. All rights reserved.
//

import UIKit
import CoreData
import MessageUI
import MapKit
import Parse

class ShowHomeTableViewController: UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, MKMapViewDelegate {

    // MARK: - Variables
    var home:Home!
    var isFavorite:Bool!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var showTableView: UITableView!

    @IBOutlet weak var favoriteSwitch: UISwitch!
    @IBOutlet weak var updateButton: UIBarButtonItem!

    @IBOutlet weak var smsButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        //mapView.delegate = self
        //title = home.streetName
        buttonState()

        //addressTextField.layer.borderColor = UIColor(red: 0.192, green: 0.192, blue: 0.192, alpha: 1.0).CGColor
       // addressTextField.layer.borderWidth = 1.0

        //tagTextField.layer.borderColor = UIColor(red: 0.192, green: 0.192, blue: 0.192, alpha: 1.0).CGColor
        //tagTextField.layer.borderWidth = 1.0
        
        //tableView.rowHeight = 44
        addressLabel.text = home.streetName
        tagLabel.text = home.tag
        //imageView.layer.cornerRadius = 50.0
        //imageView.clipsToBounds = true
        imageView.image = UIImage(data: home.image)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        //updateButton.title = ""
        //updateButton.enabled = false
        //updateButton.tintColor = UIColor(red: 0.263, green: 0.596, blue: 0.847, alpha: 0.10)

        //var imageViewObject = UIImageView()
        //imageViewObject.image = UIImage(named: "splash.jpg")
        //tableView.backgroundView = imageViewObject

        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.separatorColor = UIColor.clearColor()

//        let geoCoder = CLGeocoder()
//        geoCoder.geocodeAddressString(home.streetName, completionHandler: { placemarks, error in
//
//            if error != nil {
//                println(error)
//                return
//            }
//            if placemarks != nil && placemarks.count > 0 {
//                let placemark = placemarks[0] as CLPlacemark
//
//                let annotation = MKPointAnnotation()
//                annotation.title = self.home.streetName
//                //annotation.subtitle = self.home.city
//                annotation.coordinate = placemark.location.coordinate
//
//                self.mapView.showAnnotations([annotation], animated: true)
//                self.mapView.selectAnnotation(annotation, animated: true)
//            }
//        })

    }

    override func viewWillAppear(animated: Bool) {
        addressLabel.text = home.streetName
        tagLabel.text = home.tag
        imageView.image = UIImage(data: home.image)
        //println("home id: \(home.objectId)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - @IBActions

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

    @IBAction func shareHome(sender: AnyObject) {

        let shareMenu = UIAlertController(title: nil, message: "Share Using", preferredStyle: .ActionSheet)
        let facebookAction = UIAlertAction(title: "TODO Facebook", style: .Default, handler: nil)
        let emailAction = UIAlertAction(title: "Email", style: .Default, handler: { (action:UIAlertAction!) -> Void in

            if MFMailComposeViewController.canSendMail() {
                //return
            }

            let emailTitle = "Great Home!"
            let messageBody = "Check out this home!"
            let toRecipients = ["eprleads@gmail.com"]

            var composer = MFMailComposeViewController()
            composer.mailComposeDelegate = self
            composer.setSubject(emailTitle)
            composer.setMessageBody(messageBody, isHTML: false)
            composer.setToRecipients(toRecipients)

            //composer.navigationBar.tintColor = UIColor.whiteColor()
            //var htmlMsg = "<html><body><p>\(getHome.streetName)</p></body><html>"
            //composer.setMessageBody(htmlMsg, isHTML: true)

            self.presentViewController(composer, animated: true, completion: nil)
        })

        let smsAction = UIAlertAction(title: "SMS", style: .Default, handler: { (action:UIAlertAction!) -> Void in

            if !MFMessageComposeViewController.canSendText() {
                let alertMessage = UIAlertController(title: "SMS Unavailable", message: "Device is not capable of sending SMS", preferredStyle: .Alert)
                alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alertMessage, animated: true, completion: nil)
            }

            let messageController = MFMessageComposeViewController()
            messageController.messageComposeDelegate = self
            messageController.recipients = ["9168470003"]
            messageController.body = "Checkout this home"

            self.presentViewController(messageController, animated: true, completion: nil)
        })


        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)

        shareMenu.addAction(facebookAction)
        shareMenu.addAction(emailAction)
        shareMenu.addAction(smsAction)
        shareMenu.addAction(cancelAction)

        self.presentViewController(shareMenu, animated: true, completion: nil)

    }

    @IBAction func unwindShowHome(segue: UIStoryboardSegue) {

    }

    func saveFavorite() {

        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            if home != nil {
                home.isFavorite = isFavorite
                println(self.home.isFavorite)
//                var query = PFQuery(className:"Home")
//                query.getObjectInBackgroundWithId(home.objectId, block: { (parseHome: PFObject?, error: NSError?) -> Void in
//                    if error == nil && parseHome != nil {
//
//                        parseHome["isFavorite"] = self.home.isFavorite
//
//                        parseHome.saveInBackgroundWithBlock {
//                            (success: Bool, error: NSError!) -> Void in
//                            if (success) {
//                                // The object has been saved.
//
//                            } else {
//                                // There was a problem, check error.description
//                            }
//                        }
//                    } else {
//                        println(error)
//                    }
//                })


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
            let destinationController = segue.destinationViewController as! MapViewController
            destinationController.home = home
        }

        if segue.identifier == "webSegue" {
            let destinationController = segue.destinationViewController as! WebViewController
            destinationController.home = home
        }

        if segue.identifier == "googleSegue" {
            let destinationController = segue.destinationViewController as! GoogleViewController
            destinationController.home = home
        }

        if segue.identifier == "notesSegue" {
            let destinationViewController = segue.destinationViewController as! NotesViewController
            destinationViewController.home = home
        }

        if segue.identifier == "imageSegue" {
            let destinationViewController = segue.destinationViewController as! ImagesViewController
            destinationViewController.home = home
        }

        if segue.identifier == "updateSegue" {
            let destinationViewController = segue.destinationViewController as! UpdateHomeViewController
            destinationViewController.home = home
        }
    }


    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        switch result.value {
        case MFMailComposeResultCancelled.value:
            println("Mail Cancelled")
            RKDropdownAlert.title("Mail Cancelled", message: "", backgroundColor: UIColor.whiteColor(), textColor: UIColor.blackColor())
        case MFMailComposeResultSaved.value:
            println("Mail Saved")
            RKDropdownAlert.title("Mail Saved", message: "", backgroundColor: UIColor.whiteColor(), textColor: UIColor.blackColor())
        case MFMailComposeResultSent.value:
            println("Mail Sent")
            RKDropdownAlert.title("Mail Sent", message: "", backgroundColor: UIColor.whiteColor(), textColor: UIColor.blackColor())
        case MFMailComposeResultFailed.value:
            println("Failed to send mail")
            RKDropdownAlert.title("Failed to send mail", message: "", backgroundColor: UIColor.whiteColor(), textColor: UIColor.blackColor())
        default:
            break
        }
        dismissViewControllerAnimated(true, completion: nil)
    }


    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        switch result.value {
        case MessageComposeResultCancelled.value:
            println("SMS Cancelled")
            RKDropdownAlert.title("SMS Cancelled", message: "", backgroundColor: UIColor.whiteColor(), textColor: UIColor.blackColor())

        case MessageComposeResultFailed.value:
            let alertMessage = UIAlertController(title: "Failure", message: "Failed to send message", preferredStyle: .Alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertMessage, animated: true, completion: nil)

        case MessageComposeResultSent.value:
            println("SMS sent")
            RKDropdownAlert.title("SMS Sent", message: "", backgroundColor: UIColor.whiteColor(), textColor: UIColor.blackColor())

        default: break

        }

        dismissViewControllerAnimated(true, completion: nil)
    }
}
