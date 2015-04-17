//
//  ImagesCollectionViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 11/10/14.
//  Copyright (c) 2014 Peter Hitchcock. All rights reserved.
//

import UIKit
import CoreData

//let reuseIdentifier = "Cell"

class ImagesViewController: UIViewController, NSFetchedResultsControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    var home: Home!
    var pictures: [Picture] = []
    var feedArray: [AnyObject] = []
    var picture: Picture!
    var fetchResultController:NSFetchedResultsController!

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        //var imageViewObject = UIImageView()
        //imageViewObject.image = UIImage(named: "splash.jpg")
        //collectionView.backgroundView = imageViewObject
        //getData()
        //fetchRequest = coreDataStack.model.f
        //fetchAndReload()
        //getArray()
        getFavorite()
        //println(pictures.count)
    }

    override func viewWillAppear(animated: Bool) {
        getFavorite()
        println(home.streetName)
        println(home.pictures.count)
        println(pictures.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UICollectionViewDataSource

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return home.pictures.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ImageCollectionViewCell
        picture = pictures[indexPath.row]
        
        cell.imageView.image = UIImage(data: picture.image)
        return cell
    }

    /*
    func getData() {
        var fetchRequest = NSFetchRequest(entityName: "Home")
        let sortDescriptor = NSSortDescriptor(key: "image", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        if let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self

            var e: NSError?
            var result = fetchResultController.performFetch(&e)
            //pictures = fetchResultController.fetchedObjects as [Picture]

            if result != true {
                println(e?.localizedDescription)
            }
        }

    }
    */

    func getArray() {
        let request = NSFetchRequest(entityName: "Picture")
        let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        feedArray = context.executeFetchRequest(request, error: nil)!
        println(feedArray)
    }

    func getFavorite() {
        var fetchRequest = NSFetchRequest(entityName: "Picture")
        let sortDescriptor = NSSortDescriptor(key: "image", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        //let predicate = NSPredicate(format: "home.pictures == %@", "picture")
        //fetchRequest.predicate = predicate

        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self

            var e: NSError?
            var result = fetchResultController.performFetch(&e)
            pictures = fetchResultController.fetchedObjects as! [Picture]

            if result != true {
                println(e?.localizedDescription)
            }
        }
        collectionView.reloadData()
    }

    


    @IBAction func unwindToImages(sender: UIStoryboardSegue) {
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addImage" {
            let destinationController = segue.destinationViewController as! AddImageViewController
            destinationController.home = home
        }

        

        if segue.identifier == "showImage" {
            let destinationController = segue.destinationViewController as! ShowImageViewController
            destinationController.picture = picture
        }

    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("\(indexPath)")
    }


    // MARK: UICollectionViewDelegate


    // Uncomment this method to specify if the specified item should be highlighted during tracking
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        //actionSheetImage()
        return true
    }



    // Uncomment this method to specify if the specified item should be selected
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }



    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return true
    }

    func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {


    }

    func actionSheetImage() {

        let shareMenu = UIAlertController(title: nil, message: "Actions", preferredStyle: .ActionSheet)
            let deleteAction = UIAlertAction(title: "Delete", style: .Default, handler: { (action:UIAlertAction!) -> Void in
            if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
                //let homeToDelete = self.fetchResultController.objectAtIndexPath(indexPath) as Home
                //let imagesToDelete = self.fetchResultController.objectAtIndexPath(indexPath) as Home
                //managedObjectContext.deleteObject(homeToDelete)

                var e: NSError?
                if managedObjectContext.save(&e) != true {
                    println("delete error: \(e!.localizedDescription)")
                }
            }

        })

        let emailAction = UIAlertAction(title: "Set Home Image", style: .Default, handler: { (action:UIAlertAction!) -> Void in
            //self.sendEmail()
        })


        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)

        //shareMenu.addAction(isFavoriteAction)
        shareMenu.addAction(deleteAction)
        shareMenu.addAction(emailAction)
        //shareMenu.addAction(cameraAction)
        //shareMenu.addAction(photoLibraryAction)
        shareMenu.addAction(cancelAction)

        self.presentViewController(shareMenu, animated: true, completion: nil)


    }



    func actions() {
        var shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Share", handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in

            let shareMenu = UIAlertController(title: nil, message: "Share Using", preferredStyle: .ActionSheet)
            let facebookAction = UIAlertAction(title: "Facebook", style: .Default, handler: nil)
            let emailAction = UIAlertAction(title: "Email", style: .Default, handler: { (action:UIAlertAction!) -> Void in
                //self.sendEmail()
            })

            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)

            shareMenu.addAction(facebookAction)
            shareMenu.addAction(emailAction)
            shareMenu.addAction(cancelAction)

            self.presentViewController(shareMenu, animated: true, completion: nil)
        })
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
                let homeToDelete = self.fetchResultController.objectAtIndexPath(indexPath) as! Home
                //let imagesToDelete = self.fetchResultController.objectAtIndexPath(indexPath) as Home
                managedObjectContext.deleteObject(homeToDelete)

                var e: NSError?
                if managedObjectContext.save(&e) != true {
                    println("delete error: \(e!.localizedDescription)")
                }
            }


        })


        shareAction.backgroundColor = UIColor(red: 215.0/255.0, green: 215.0/255.0, blue: 215.0/255.0, alpha: 1.0)
        
        //return [shareAction, deleteAction]
        

    }

}
