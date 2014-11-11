//
//  AddImageViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 11/10/14.
//  Copyright (c) 2014 Peter Hitchcock. All rights reserved.
//

import UIKit

class AddImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var home: Home!
    var picture: Picture!

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if home != nil {
            println(home.streetName)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func saveImage(sender: AnyObject) {
        saveImage()
    }

    @IBAction func grabImage(sender: AnyObject) {
        takePic()
    }

    func takePic() {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .PhotoLibrary
            imagePicker.delegate = self
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imageView.image = image
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true

        dismissViewControllerAnimated(true, completion: nil)
    }

    func saveImage() {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {
            let entityDescription = NSEntityDescription.entityForName("Picture", inManagedObjectContext: managedObjectContext)
            let picture = Picture(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
            picture.image = UIImagePNGRepresentation(imageView.image)

            var pictures = home.pictures.mutableCopy() as NSMutableSet
            pictures.addObject(picture)

            home.pictures = pictures.copy() as NSSet

            var e: NSError?
            if managedObjectContext.save(&e) != true {
                println("error")
                return
            }
        }
    }



}
