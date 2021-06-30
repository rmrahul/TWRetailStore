//
//  ProductStoreProtocol.swift
//  RetailStore
//
//  Created by Rahul Mane on 21/07/18.
//  Copyright © 2018 developer. All rights reserved.
//

import Foundation

protocol ProductStoreProtocol{
    func fetch(completionHandler: @escaping ProductsStoreFetchProductsCompletionHandler)
}

// MARK: - Product store result
enum ProductStoreResult<U>{
    case success(result: U)
    case failure(error: ProductStoreError)
}

// MARK: - Product store errors
enum ProductStoreError: Equatable, Error{
    case CannotFetch(String)
    case CannotCreate(String)
    case CannotUpdate(String)
    case CannotDelete(String)
}

func ==(lhs: ProductStoreError, rhs: ProductStoreError) -> Bool {
    switch (lhs, rhs) {
    case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
    case (.CannotCreate(let a), .CannotCreate(let b)) where a == b: return true
    case (.CannotUpdate(let a), .CannotUpdate(let b)) where a == b: return true
    case (.CannotDelete(let a), .CannotDelete(let b)) where a == b: return true
    default: return false
    }
}

typealias ProductsStoreFetchProductsCompletionHandler = (ProductStoreResult<[Product]>) -> Void
