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
    //var pictures: [Picture] = []
    //var fetchResultController:NSFetchedResultsController!

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        //var imageViewObject = UIImageView()
        //imageViewObject.image = UIImage(named: "splash.jpg")
        //collectionView.backgroundView = imageViewObject
        //getData()
        //fetchRequest = coreDataStack.model.f
        //fetchAndReload()
        getArray()
        //getFavorite()
        //println(pictures.count)
    }

    override func viewDidAppear(animated: Bool) {
        collectionView.reloadData()
        println(home.streetName)
        println(home.pictures.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UICollectionViewDataSource

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return home.pictures.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as ImageCollectionViewCell
        //let p = picture.home[indexPath.row]
        //let thisItem = feedArray[indexPath.row]
        
        cell.imageView.image = UIImage(named: "heartColor")
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
        let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        feedArray = context.executeFetchRequest(request, error: nil)!
        println(feedArray)
    }

    func getFavorite() {
        var fetchRequest = NSFetchRequest(entityName: "Home")
        let sortDescriptor = NSSortDescriptor(key: "image", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "home.pictures == %@", "picture")
        fetchRequest.predicate = predicate

        if let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self

            var e: NSError?
            var result = fetchResultController.performFetch(&e)
            pictures = fetchResultController.fetchedObjects as [Picture]

            if result != true {
                println(e?.localizedDescription)
            }
        }
    }


    @IBAction func unwindToImages(sender: UIStoryboardSegue) {
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addImage" {
            let destinationController = segue.destinationViewController as AddImageViewController
            destinationController.home = home
        }

        if segue.identifier == "popSegue" {
            let destinationController = segue.destinationViewController as PopViewController
            destinationController.home = home
        }
    }
    /*
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

    }
    */

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
