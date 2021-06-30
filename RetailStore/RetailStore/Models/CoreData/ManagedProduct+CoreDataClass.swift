//
//  ManagedProduct+CoreDataClass.swift
//  
//
//  Created by Rahul Mane on 23/07/18.
//

import Foundation
import CoreData

@objc(ManagedProduct)
public class ManagedProduct: NSManagedObject {
    func toProduct() -> Product{
        return Product(id: id ?? "0", name: name ?? "", price: price, category: category ?? "", images: images ?? [],count:Int(count))
    }
    
    func fromProduct(product : Product){
        id = product.id
        name = product.name
        price = product.price
        category = product.category
        images = product.images
        count = Int32(product.count)
    }
}
