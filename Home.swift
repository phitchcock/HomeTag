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

    @NSManaged var city: String
    @NSManaged var image: NSData
    @NSManaged var note: String
    @NSManaged var state: String
    @NSManaged var streetName: String
    @NSManaged var streetNumber: String
    @NSManaged var zip: String
    @NSManaged var isFavorite: NSNumber

}
