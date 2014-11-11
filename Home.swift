//
//  HomeTag.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 11/10/14.
//  Copyright (c) 2014 Peter Hitchcock. All rights reserved.
//

import Foundation
import CoreData

//@objc(Home)

class Home: NSManagedObject {

    @NSManaged var image: NSData
    @NSManaged var isFavorite: NSNumber
    @NSManaged var note: String
    @NSManaged var streetName: String
    @NSManaged var tag: String
    @NSManaged var thumbNail: NSData
    @NSManaged var pictures: NSSet
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber

}
