//
//  Product.swift
//  RetailStore
//
//  Created by Rahul Mane on 21/07/18.
//  Copyright © 2018 developer. All rights reserved.
//

import UIKit

struct Product : Codable,Equatable {
    var id: String
    var name: String
    var price: Double
    var category: String
    var images : [String] = []
    var count = 1
    
    init(id : String, name : String,price : Double,category : String, images : [String]) {
        self.id = id
        self.name = name
        self.price = price
        self.category = category
        self.images = images
    }
    
    init(id : String, name : String,price : Double,category : String, images : [String],count : Int) {
        self.init(id: id, name: name, price: price, category: category, images: images)
        self.count = count
    }
}

func ==(lhs: Product, rhs: Product) -> Bool{
    return lhs.name == rhs.name
        && lhs.price == rhs.price
        && lhs.category == rhs.category
        && lhs.id == rhs.id
}
