//
//  MockData.swift
//  RetailStoreTests
//
//  Created by Rahul Mane on 23/07/18.
//  Copyright © 2018 developer. All rights reserved.
//

@testable import RetailStore

struct MockData {
    struct Products  {
        static let oven = Product(id: "99", name: "Oven", price: 99.0, category: "Kitchen", images: ["URL1","URL2"])
        static let table = Product(id: "100", name: "Table", price: 100.0, category: "Kitchen", images: ["URL1","URL2"])
        static let fridge = Product(id: "101", name: "fridge", price: 103.0, category: "Bathroom", images: ["URL1","URL2"])
        static let washingmachine = Product(id: "102", name: "washingmachine", price: 102.0, category: "Bathroom", images: ["URL1","URL2"])
        
        static let memStore = [oven,table,fridge,washingmachine]
        static let memStoreFiltered : [String : [Product]] = ["Kitchen" : [oven,table],
                                      "Bathroom" : [fridge,washingmachine]]

        static let memStoreTotalAmount = "\(oven.price + table.price + fridge.price + washingmachine.price)"
        
        static let cantCreate = CartStoreError.CannotCreate("Can't create")
        static let cantFetch = CartStoreError.CannotFetch("Can't fetch")
        static let cantDelete = CartStoreError.CannotDelete("Can't delete")
    }
}
