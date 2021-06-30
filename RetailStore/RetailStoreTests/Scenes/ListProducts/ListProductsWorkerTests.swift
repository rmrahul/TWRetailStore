//
//  ListProductsWorker.swift
//  RetailStoreTests
//
//  Created by Rahul Mane on 23/07/18.
//  Copyright © 2018 developer. All rights reserved.
//

import XCTest
@testable import RetailStore

class ListProductsWorkerTests: XCTestCase {
    var sut: ListProductsWorker!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ListProductsWorker(productStore: ProductStoreProtocolSpy())
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    class ProductStoreProtocolSpy : ProductStoreProtocol{
        func fetch(completionHandler: @escaping ProductsStoreFetchProductsCompletionHandler){
            completionHandler(.success(result:MockData.Products.memStore))
        }
    }
    
    //MARK: Tests
    func test_fetch_products_success() {
        // Given
        
        //when
        let expect = expectation(description: "Wait for fetchAll() to return")
        var fetchedProducts : [Product]?
        var fetchedError : ProductStoreError?
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
}
