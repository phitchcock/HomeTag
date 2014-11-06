//
//  NotesViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 11/4/14.
//  Copyright (c) 2014 Peter Hitchcock. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {

    // MARK: - Variables
    var home:Home!
    var notes:String!

    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = home.note
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func endEditing(sender: AnyObject) {
        saveHome()
    }

    // MARK: - CoreData
    func saveHome() {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {
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
}
