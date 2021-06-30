//
//  ListProductsInteractorTests.swift
//  RetailStoreTests
//
//  Created by Rahul Mane on 23/07/18.
//  Copyright © 2018 developer. All rights reserved.
//

import XCTest
@testable import RetailStore

class ListProductsInteractorTests: XCTestCase {
    //MARK: Subject under test
    var sut: ListProductsInteractor!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ListProductsInteractor()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Test doubles
    class ListProductPresentationLogicSpy: ListProductsPresentationLogic{
        // MARK: Method call expectations
        var presentFetchedProductCalled = false
        var isExpectedResponse = false

        // MARK: Spied methods
        func presentProducts(response: ListProducts.Fetch.Response) {
            presentFetchedProductCalled = true
            guard let products = response.products else {
                return
            }

            if(MockData.Products.memStoreFiltered.count == products.count){
                isExpectedResponse = true
            }
        }
    }
    
    class ListProductWorkerSpy: ListProductsWorker{
        // MARK: Method call expectations
        var fetchProductCalled = false
        
        // MARK: Spied methods
        override func fetchAll(completionHandler: @escaping ProductsStoreFetchProductsCompletionHandler) {
            fetchProductCalled = true
            completionHandler(.success(result:MockData.Products.memStore))
        }
    }
    
    class ListProductWorkerFailedSpy: ListProductsWorker{
        // MARK: Method call expectations
        var fetchProductCalled = false
        
        // MARK: Spied methods
        override func fetchAll(completionHandler: @escaping ProductsStoreFetchProductsCompletionHandler) {
            fetchProductCalled = true
            completionHandler(.failure(error :ProductStoreError.CannotFetch("Can't fetch")))
        }
    }
    
    class ListProductPresentationLogicFailedSpy: ListProductsPresentationLogic{
        // MARK: Method call expectations
        var presentFetchedProductCalled = false
        var isExpectedResponse = false
        
        // MARK: Spied methods
        func presentProducts(response: ListProducts.Fetch.Response) {
            presentFetchedProductCalled = true

            if(response.error == ProductStoreError.CannotFetch("Can't fetch") && response.products == nil){
                isExpectedResponse = true
            }
        }
    }
    
    // MARK: - Tests
    func test_fetch_products_ask_worker_and_provide_result_to_presenter() {
        // Given
        let listProductPresentationLogicSpy = ListProductPresentationLogicSpy()
        sut.presenter = listProductPresentationLogicSpy
        let listProductWorkerSpy = ListProductWorkerSpy(productStore: ProductsMemStore())
        sut.worker = listProductWorkerSpy
        
        // When
        let request = ListProducts.Fetch.Request()
        sut.fetchProducts(request: request)
        
        // Then
        XCTAssert(listProductWorkerSpy.fetchProductCalled, "fetchProducts() should ask worker to fetch products")
        XCTAssert(listProductPresentationLogicSpy.presentFetchedProductCalled, "fetchProducts() should ask presenter to format products result")
        XCTAssert(listProductPresentationLogicSpy.isExpectedResponse, "fetchProducts() should provided all data from memstore")
    }
    
    func test_fetch_products_ask_worker_worker_failture_and_provide_result_to_presenter() {
        // Given
        let listProductPresentationLogicSpy = ListProductPresentationLogicFailedSpy()
        sut.presenter = listProductPresentationLogicSpy
        let listProductWorkerSpy = ListProductWorkerFailedSpy(productStore: ProductsMemStore())
        sut.worker = listProductWorkerSpy
        
        // When
        let request = ListProducts.Fetch.Request()
        sut.fetchProducts(request: request)
        
        // Then
        XCTAssert(listProductWorkerSpy.fetchProductCalled, "fetchProducts() should ask worker to fetch products")
        XCTAssert(listProductPresentationLogicSpy.presentFetchedProductCalled, "fetchProducts() should ask presenter to format products result")
        XCTAssert(listProductPresentationLogicSpy.isExpectedResponse, "fetchProducts() should provided all data from memstore")
    }
}
