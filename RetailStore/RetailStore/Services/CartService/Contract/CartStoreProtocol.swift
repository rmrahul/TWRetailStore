//
//  CartStoreProtocol.swift
//  RetailStore
//
//  Created by Rahul Mane on 21/07/18.
//  Copyright © 2018 developer. All rights reserved.
//

import UIKit

protocol CartStoreProtocol {
    func add(product : Product,completionHandler:@escaping CartStoreAddProductCompletionHandler)
    func update(product : Product,completionHandler:@escaping CartStoreUpdateProductCompletionHandler)
    func fetch(productId : String,completionHandler:@escaping CartStoreFetchProductCompletionHandler)
    func fetchAll(completionHandler: @escaping CartStoreFetchProductsCompletionHandler)
    func remove(productId : String, completionHandler : @escaping CartStoreRemoveProductCompletionHandler)
}

// MARK: - Product store result
enum CartStoreResult<U>{
    case success(result: U)
    case failure(error: CartStoreError)
}

// MARK: - Product store errors
enum CartStoreError: Equatable, Error{
    case CannotFetch(String)
    case CannotCreate(String)
    case CannotUpdate(String)
    case CannotDelete(String)
}

func ==(lhs: CartStoreError, rhs: CartStoreError) -> Bool {
    switch (lhs, rhs) {
    case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
    case (.CannotCreate(let a), .CannotCreate(let b)) where a == b: return true
    case (.CannotUpdate(let a), .CannotUpdate(let b)) where a == b: return true
    case (.CannotDelete(let a), .CannotDelete(let b)) where a == b: return true
    default: return false
    }
}

typealias CartStoreFetchProductsCompletionHandler = (CartStoreResult<[Product]>) -> Void
typealias CartStoreAddProductCompletionHandler = (CartStoreResult<Product>) -> Void
typealias CartStoreUpdateProductCompletionHandler = (CartStoreResult<Product>) -> Void
typealias CartStoreFetchProductCompletionHandler = (CartStoreResult<Product>) -> Void
typealias CartStoreRemoveProductCompletionHandler = (CartStoreResult<Bool>) -> Void
