//
//  ShowImageViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 11/17/14.
//  Copyright (c) 2014 Peter Hitchcock. All rights reserved.
//

import UIKit

class ShowImageViewController: UIViewController {

    var picture: Picture!

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //imageView.image = UIImage(data: picture.image)
        // Do any additional setup after loading the view.
        imageView.image = UIImage(data: picture.image)
    }

    override func viewDidAppear(animated: Bool) {
        imageView.image = UIImage(data: picture.image)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
