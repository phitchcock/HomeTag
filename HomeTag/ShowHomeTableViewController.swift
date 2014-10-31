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

    override func viewDidLoad() {
        super.viewDidLoad()
        streetAddressLabel.text = home.streetName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
