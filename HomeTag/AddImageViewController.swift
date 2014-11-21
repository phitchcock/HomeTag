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
        navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func grabImage(sender: AnyObject) {
        selectImage()
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
            picture.image = UIImageJPEGRepresentation(imageView.image, 0.1)

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

        shareMenu.addAction(cameraAction)
        shareMenu.addAction(photoLibraryAction)
        shareMenu.addAction(cancelAction)

        self.presentViewController(shareMenu, animated: true, completion: nil)
        
    }

}
