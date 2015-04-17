//
//  NotesViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 11/4/14.
//  Copyright (c) 2014 Peter Hitchcock. All rights reserved.
//

import UIKit
import CoreData


class NotesViewController: UIViewController, UITextViewDelegate {

    // MARK: - Variables
    var home:Home!
    var notes:String!

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var notesImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.text = home.note
        doneButton.title = ""
        doneButton.enabled = false
        notesImageView.image = UIImage(data: home.image)
        //doneButton.tintColor = UIColor(red: 0.263, green: 0.596, blue: 0.847, alpha: 0.10)
    }

    override func viewWillAppear(animated: Bool) {
        //screenName = "Notes"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func endEditing(sender: AnyObject) {
        saveHome()
        doneButton.title = ""
        doneButton.enabled = false
        //doneButton.tintColor = UIColor(red: 0.263, green: 0.596, blue: 0.847, alpha: 0.10)
        textView.resignFirstResponder()
        navigationController?.popViewControllerAnimated(true)
    }

    // MARK: - CoreData
    func saveHome() {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            if home != nil {
                home.note = textView.text
            }
            var e: NSError?
            if managedObjectContext.save(&e) != true {
                println("insert error: \(e!.localizedDescription)")
                return
            }
        }
    }
    func textViewDidBeginEditing(textView: UITextView) {
        println("touched")
        //doneButton.tintColor = UIColor(red: 0.086, green: 0.494, blue: 0.655, alpha: 1.0)
        doneButton.enabled = true 
        doneButton.title = "Done"
    }

    func textViewDidEndEditing(textView: UITextView) {
        println("done")
    }


}
