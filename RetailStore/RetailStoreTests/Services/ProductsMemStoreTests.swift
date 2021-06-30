//
//  ProductsMemStoreTests.swift
//  RetailStoreTests
//
//  Created by Rahul Mane on 23/07/18.
//  Copyright © 2018 developer. All rights reserved.
//

import XCTest
@testable import RetailStore
class ProductsMemStoreTests: XCTestCase {
    var sut : ProductsMemStore!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ProductsMemStore()
        setUpMemStore()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        flushData()
    }
    
    //MARK: Mocking
    func setUpMemStore(){
        ProductsMemStore.products = MockData.Products.memStore
    }
    
    func flushData(){
        ProductsMemStore.products = []
    }
    
    //MARK: Tests
    func test_fetch_product_should_return_success() {
        //given
        let savedProduct = MockData.Products.memStore
        
        //when
        let expect = expectation(description: "Wait for fetchproducts() to return")
        var fetchedProducts : [Product] = []
        var fetchedError : ProductStoreError?
        
        sut.fetch(){ (result) in
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
        
        //then
        XCTAssertEqual(fetchedProducts.count, savedProduct.count,"fetch() should return all objects")
        XCTAssertNil(fetchedError, "fetch() should not return an error")
        for p in fetchedProducts{
            XCTAssert(savedProduct.contains(where: { $0 == p }),"fetch() should match the products in the data store")
        }
    }
}
