//
//  Bowtie+CoreDataProperties.swift
//  Bow Ties
//
//  Created by Xing Hui Lu on 1/22/16.
//  Copyright © 2016 Razeware. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

/*
    Managed object subclasses unleash the syntactic power of Swift properties. 
    By accessing attributes using properties instead of key-value coding, 
    you again befriend Xcode and the compiler.
*/

extension Bowtie {

    @NSManaged var name: String?
    @NSManaged var isFavorite: NSNumber?
    @NSManaged var lastWorn: NSDate?
    @NSManaged var rating: NSNumber?
    @NSManaged var searchKey: String?
    @NSManaged var timesWorn: NSNumber?
    @NSManaged var photoData: NSData?
    @NSManaged var tintColor: NSObject?

}
