//
//  HomeTag.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 11/10/14.
//  Copyright (c) 2014 Peter Hitchcock. All rights reserved.
//

import Foundation
import CoreData

//@objc(Picture)

class Picture: NSManagedObject {

    @NSManaged var image: NSData
    @NSManaged var caption: String
    @NSManaged var home: Home

}
