//
//  HomesTableViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 10/31/14.
//  Copyright (c) 2014 Peter Hitchcock. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class HomesViewController: UIViewController, NSFetchedResultsControllerDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Variables
    var homes: [Home] = []
    var home: Home!
    var favorites: [Home] = []
    var fetchResultController:NSFetchedResultsController!


    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        tabBarController?.selectedIndex = 1

        //tableView.rowHeight = 265
        //tableView.backgroundColor = UIColor(red: 0.941, green: 0.957, blue: 0.965, alpha: 1.0)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.separatorColor = UIColor.clearColor()

        getData()



    }

    override func viewWillAppear(animated: Bool) {

        if favorites.isEmpty {

        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func segmentChangeIndex(sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            getData()
            tableView.reloadData()
        case 1:
            getFavorite()
            tableView.reloadData()
            println(favorites.count)
        default:
            break
        }
    }

    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if homes.count == 0 {

            var imageNotification = UIImage(named: "error.png")
            var imageView = UIImageView(image: imageNotification)
            
            imageView.backgroundColor = UIColor(red: 0.263, green: 0.596, blue: 0.847, alpha: 1)
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            imageView.clipsToBounds = true
            tableView.addSubview(imageView)
            tableView.backgroundView = imageView

        } else {
            tableView.backgroundView = nil

        }

        if segmentedControl.selectedSegmentIndex == 0 {
            return self.homes.count

        } else {
            return favorites.count
        }

    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as HomeCellTableViewCell

        if segmentedControl.selectedSegmentIndex == 0 {
            let home = homes[indexPath.row]
            cell.addressLabel.text = home.streetName
            cell.tagLabel.text = home.tag
            cell.homeImageView.image = UIImage(data: home.thumbNail)
            cell.homeImageView.clipsToBounds = true
            cell.favoriteImageView.hidden = !home.isFavorite.boolValue
            return cell

        } else {
            let favorite = favorites[indexPath.row]
            cell.addressLabel.text = favorite.streetName
            cell.tagLabel.text = favorite.tag
            cell.homeImageView.image = UIImage(data: favorite.thumbNail)
            cell.homeImageView.clipsToBounds = true
            cell.favoriteImageView.hidden = !favorite.isFavorite.boolValue
            return cell
        }
    }

    // MARK: - CoreData
    func getData() {
        var fetchRequest = NSFetchRequest(entityName: "Home")
        let sortDescriptor = NSSortDescriptor(key: "streetName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        if let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self

            var e: NSError?
            var result = fetchResultController.performFetch(&e)
            homes = fetchResultController.fetchedObjects as [Home]

            if result != true {
                println(e?.localizedDescription)
            }
        }
    }

    func getFavorite() {
        var fetchRequest = NSFetchRequest(entityName: "Home")
        let sortDescriptor = NSSortDescriptor(key: "isFavorite", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "isFavorite == true")
        fetchRequest.predicate = predicate

        if let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self

            var e: NSError?
            var result = fetchResultController.performFetch(&e)
            favorites = fetchResultController.fetchedObjects as [Home]

            if result != true {
                println(e?.localizedDescription)
            }
        }
    }

    func controllerWillChangeContent(controller: NSFetchedResultsController!) {
        tableView.beginUpdates()
    }

    func controller(controller: NSFetchedResultsController!, didChangeObject anObject: AnyObject!, atIndexPath indexPath: NSIndexPath!, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath!) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        case .Update:
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        default:
            tableView.reloadData()
        }
        homes = controller.fetchedObjects as [Home]
        favorites = controller.fetchedObjects as [Home]
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        tableView.endUpdates()
    }

    // MARK: - tableView editActions
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {

        var shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Share", handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in

            let shareMenu = UIAlertController(title: nil, message: "Share Using", preferredStyle: .ActionSheet)
            let facebookAction = UIAlertAction(title: "Facebook", style: .Default, handler: nil)
            let emailAction = UIAlertAction(title: "Email", style: .Default, handler: { (action:UIAlertAction!) -> Void in
                self.sendEmail()
            })

            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)

            shareMenu.addAction(facebookAction)
            shareMenu.addAction(emailAction)
            shareMenu.addAction(cancelAction)

            self.presentViewController(shareMenu, animated: true, completion: nil)
        })
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            if let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {
                let homeToDelete = self.fetchResultController.objectAtIndexPath(indexPath) as Home
                managedObjectContext.deleteObject(homeToDelete)

                var e: NSError?
                if managedObjectContext.save(&e) != true {
                    println("delete error: \(e!.localizedDescription)")
                }
            }
        })
        shareAction.backgroundColor = UIColor(red: 215.0/255.0, green: 215.0/255.0, blue: 215.0/255.0, alpha: 1.0)

        return [deleteAction, shareAction]
    }

    @IBAction func unwind(segue: UIStoryboardSegue) {
        
    }

    // MARK: - prepareForSegue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showHomeSegue" {
            if let row = tableView.indexPathForSelectedRow()?.row {
                if segmentedControl.selectedSegmentIndex == 0 {
                    let destinationController = segue.destinationViewController as ShowHomeTableViewController
                    destinationController.home = homes[row]
                }
                if segmentedControl.selectedSegmentIndex == 1 {
                    let destinationController = segue.destinationViewController as ShowHomeTableViewController
                    destinationController.home = favorites[row]
                }
            }
        }
    }

    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            var composer = MFMailComposeViewController()
            composer.mailComposeDelegate = self
            composer.navigationBar.tintColor = UIColor.whiteColor()

            var htmlMsg = "<html><body><p>\(home.streetName)</p></body><html>"

            composer.setMessageBody(htmlMsg, isHTML: true)

            presentViewController(composer, animated: true, completion: nil)
        }
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

    @IBAction func segueTest(sender: AnyObject) {
        //performSegueWithIdentifier("googleSegue", sender: AnyObject.self)
    }
}
