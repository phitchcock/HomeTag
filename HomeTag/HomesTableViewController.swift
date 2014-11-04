//
//  HomesTableViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 10/31/14.
//  Copyright (c) 2014 Peter Hitchcock. All rights reserved.
//

import UIKit
import CoreData

class HomesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var homes: [Home] = []
    var fetchResultController:NSFetchedResultsController!

    @IBOutlet var homesTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }

    override func viewWillAppear(animated: Bool) {
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homes.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as HomeCellTableViewCell
        let home = homes[indexPath.row]
        cell.addressLabel.text = home.streetName
        cell.homeImageView.image = UIImage(data: home.image)
        //cell.homeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        //cell.homeImageView.clipsToBounds = true
        //cell.accessoryType = !home.isFavorite.boolValue


        return cell
    }

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
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        tableView.endUpdates()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showHomeSegue" {
            if let row = tableView.indexPathForSelectedRow()?.row {
                let destinationController = segue.destinationViewController as ShowHomeTableViewController
                destinationController.home = homes[row]
            }
        }
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
   
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Share", handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in

            let shareMenu = UIAlertController(title: nil, message: "Share Using", preferredStyle: .ActionSheet)
            let facebookAction = UIAlertAction(title: "Facebook", style: .Default, handler: nil)
            let emailAction = UIAlertAction(title: "Email", style: .Default, handler: nil)
            let isFavoriteAction = UIAlertAction(title: "Favorite?", style: .Default, handler: { (action:UIAlertAction!) -> Void in
                let cell = tableView.cellForRowAtIndexPath(indexPath)
                cell?.accessoryType = .Checkmark
                //self.homeIsFavorite[indexPath.row] = true
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)

            shareMenu.addAction(isFavoriteAction)
            shareMenu.addAction(facebookAction)
            shareMenu.addAction(emailAction)
            shareMenu.addAction(cancelAction)

            self.presentViewController(shareMenu, animated: true, completion: nil)

        })
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in

            if let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {

                let homeToDelete = self.fetchResultController.objectAtIndexPath(indexPath) as Home
                managedObjectContext.deleteObject(homeToDelete)

                println("\(homeToDelete.streetName)")

                var e: NSError?
                if managedObjectContext.save(&e) != true {
                    println("delete error: \(e!.localizedDescription)")
                }
            }
        })
        shareAction.backgroundColor = UIColor(red: 255.0/255.0, green: 166.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        return [deleteAction, shareAction]
    }

    func unwind(segue: UIStoryboardSegue) {
        
    }



}
