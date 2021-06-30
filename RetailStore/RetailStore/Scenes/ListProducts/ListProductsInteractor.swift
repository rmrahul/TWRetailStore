//
//  ListProductsInteractor.swift
//  RetailStore
//
//  Created by Rahul Mane on 21/07/18.
//  Copyright (c) 2018 developer. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ListProductsBusinessLogic{
    func fetchProducts(request: ListProducts.Fetch.Request)
}

protocol ListProductsDataStore{
    var products: [String : [Product]]? { get }
}

class ListProductsInteractor: ListProductsBusinessLogic, ListProductsDataStore{
    var worker: ListProductsWorker = ListProductsWorker(productStore: ProductsMemStore())
    var presenter: ListProductsPresentationLogic?
    var products: [String : [Product]]?
    
    // MARK: ListProductsBusinessLogic implementation
    func fetchProducts(request: ListProducts.Fetch.Request){
        worker.fetchAll(completionHandler: { (result) in
            var response : ListProducts.Fetch.Response
            switch(result){
            case .success(let products):
                let result = products.reduce(into: [String : [Product]]()){ r , value in
                    r[value.category,default:[]].append(value)
                }
                self.products = result
                response = ListProducts.Fetch.Response(products: result, error: nil)
            case .failure(let error):
                response = ListProducts.Fetch.Response(products: nil, error: error)
            }
            self.presenter?.presentProducts(response: response)
        })
    }
}