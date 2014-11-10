//
//  HomeTag.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 11/4/14.
//  Copyright (c) 2014 Peter Hitchcock. All rights reserved.
//

import Foundation
import CoreData

class Home: NSManagedObject {

    @NSManaged var image: NSData
    @NSManaged var thumbNail: NSData
    @NSManaged var note: String
    @NSManaged var streetName: String
    @NSManaged var isFavorite: NSNumber
    @NSManaged var tag: String

}
