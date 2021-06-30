//
//  ManagedProduct+CoreDataProperties.swift
//  
//
//  Created by Rahul Mane on 23/07/18.
//

import Foundation
import CoreData


extension ManagedProduct {

    @nonobjc public class func productFetchRequest() -> NSFetchRequest<ManagedProduct> {
        return NSFetchRequest<ManagedProduct>(entityName: "ManagedProduct")
    }

    @NSManaged public var images: [String]?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var category: String?
    @NSManaged public var count: Int32
    @NSManaged public var price: Double

}
