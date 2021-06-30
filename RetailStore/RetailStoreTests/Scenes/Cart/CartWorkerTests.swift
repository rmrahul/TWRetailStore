//
//  CartWorkerTests.swift
//  RetailStoreTests
//
//  Created by Rahul Mane on 23/07/18.
//  Copyright © 2018 developer. All rights reserved.
//

import XCTest
@testable import RetailStore

class CartWorkerTests: XCTestCase {
    var sut: CartWorker!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = CartWorker(cartStore: CartStoreProtocolSpy())
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
    func test_fetch_products_ask_worker_success() {
        // Given
        
        //when
        let expect = expectation(description: "Wait for fetch() to return")
        var fetchedProducts : [Product]?
        var fetchedError : CartStoreError?
        sut.fetchAll() { (result) in
            switch(result){
            case .success(let p):
                fetchedProducts = p
                break
            case .failure(let error):
                fetchedError = error
            }
            expect.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        
        // Then
        XCTAssertNotNil(fetchedProducts,"fetchAll() Product should not be nil")
        XCTAssertEqual(fetchedProducts!.count, MockData.Products.memStore.count,"fetchAll() should return all objects")
        for p in fetchedProducts!{
            XCTAssert(MockData.Products.memStore.contains(where: { $0 == p }),"fetchAll() should match the products in the data store")
        }
        XCTAssertNil(fetchedError, "fetchAll() should not return an error")
    }
    
    func test_remove_product_ask_worker_success() {
        // Given
        let productId = MockData.Products.oven.id
        
        //when
        let expect = expectation(description: "Wait for fetch() to return")
        var isSuccess : Bool?
        var fetchedError : CartStoreError?
        sut.removeProduct(productId: productId) { (result) in
            switch(result){
            case .success(let p):
                isSuccess = p
                break
            case .failure(let error):
                fetchedError = error
            }
            expect.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        
        // Then
        XCTAssertNotNil(isSuccess,"removeProduct() Product should not be nil")
        XCTAssert(isSuccess!, "removeProduct() should return true")
        XCTAssertNil(fetchedError, "fetchAll() should not return an error")
    }
}
