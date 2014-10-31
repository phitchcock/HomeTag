//
//  ShowHomeTableViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 10/31/14.
//  Copyright (c) 2014 Peter Hitchcock. All rights reserved.
//

import UIKit
import CoreData

class ShowHomeTableViewController: UITableViewController {

    var home:Home!

    @IBOutlet weak var streetAddressLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        streetAddressLabel.text = home.streetName
        imageView.image = UIImage(data: home.image)
        textView.text = home.note
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
