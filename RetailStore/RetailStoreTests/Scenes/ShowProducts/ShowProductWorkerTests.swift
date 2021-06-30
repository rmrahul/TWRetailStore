//
//  ShowProductWorkerTests.swift
//  RetailStoreTests
//
//  Created by Rahul Mane on 23/07/18.
//  Copyright © 2018 developer. All rights reserved.
//

import XCTest
@testable import RetailStore

class ShowProductWorkerTests: XCTestCase {
    var sut: ShowProductWorker!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ShowProductWorker(cartStore: CartStoreProtocolSpy())
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    class CartStoreProtocolSpy: CartStoreProtocol{
        // MARK: Method call expectations
        var addCalled = false
        var updatedCalled = false
        var fetchCalled = false
        var fetchAllCalled = false
        var removeCalled = false
        
        // MARK: Spied methods
        func add(product: Product, completionHandler: @escaping CartStoreAddProductCompletionHandler) {
            addCalled = true
            completionHandler(.success(result:product))
        }
        
        func update(product: Product, completionHandler: @escaping CartStoreUpdateProductCompletionHandler) {
            updatedCalled = true
            completionHandler(.success(result:product))
        }
        
        func fetch(productId: String, completionHandler: @escaping CartStoreFetchProductCompletionHandler) {
            fetchCalled = true
            completionHandler(.success(result:MockData.Products.oven))
        }
        
        func fetchAll(completionHandler: @escaping CartStoreFetchProductsCompletionHandler) {
            fetchAllCalled = true
            completionHandler(.success(result:MockData.Products.memStore))
        }
        
        func remove(productId: String, completionHandler: @escaping CartStoreRemoveProductCompletionHandler) {
            completionHandler(.success(result:true))
        }
    }
    
    //MARK: Tests
    func test_add_cart_success() {
        // Given
        let product = MockData.Products.oven
        
        //when
        let expect = expectation(description: "Wait for addToCart() to return")
        var fetchedProduct : Product?
        var fetchedError : CartStoreError?
        sut.addToCart(product: product){ (result) in
            switch(result){
            case .success(let p):
                fetchedProduct = p
                break
            case .failure(let error):
                fetchedError = error
            }
            expect.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        
        // Then
        XCTAssertNotNil(fetchedProduct,"addToCart() Product should not be nil")
        XCTAssert(fetchedProduct!.id == MockData.Products.oven.id,"addToCart() should return all objects")
        XCTAssertNil(fetchedError, "addToCart() should not return an error")
    }
}
