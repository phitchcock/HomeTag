//
//  UpdateHomeViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 11/21/14.
//  Copyright (c) 2014 Peter Hitchcock. All rights reserved.
//

import UIKit
import CoreData

class UpdateHomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var home: Home!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        //imageView.image = UIImage(data: home.image)
        addressTextField.text = home.streetName
        tagTextField.text = home.tag

        imageButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        imageButton.layer.borderWidth = 1.0
        imageButton.layer.cornerRadius = 5

        updateButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        updateButton.layer.borderWidth = 1
        updateButton.layer.cornerRadius = 5


    }

    override func viewWillAppear(animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imageView.image = image
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true

        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func getImage(sender: AnyObject) {
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

    @IBAction func update(sender: AnyObject) {
        saveHome()
        //saveImage()
        saveTag()
        navigationController?.popViewControllerAnimated(true)
    }

    func saveHome() {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
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


    func saveImage() {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            if home != nil {
                home.image = UIImageJPEGRepresentation(imageView.image, 0.1)
                //home.thumbNail = UIImageJPEGRepresentation(imageView.image, 0.1)
            }

            var e: NSError?
            if managedObjectContext.save(&e) != true {
                println("insert error: \(e!.localizedDescription)")
                return
            }
        }
    }

    func saveTag() {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
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

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        addressTextField.resignFirstResponder()
        tagTextField.resignFirstResponder()
        return true
    }


}
