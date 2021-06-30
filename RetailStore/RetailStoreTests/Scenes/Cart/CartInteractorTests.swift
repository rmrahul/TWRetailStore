//
//  CartInteractorTests.swift
//  RetailStoreTests
//
//  Created by Rahul Mane on 23/07/18.
//  Copyright © 2018 developer. All rights reserved.
//

import XCTest
@testable import RetailStore

class CartInteractorTests: XCTestCase {
    var sut : CartInteractor!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = CartInteractor()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Test doubles
    class CartPresentationLogicSpy: CartPresentationLogic{
        // MARK: Method call expectations
        var presentProductViewModel : Cart.FetchProducts.Response?
        var removeProductViewModel : Cart.RemoveProduct.Response?

        // MARK: Spied methods
        func presentProducts(response: Cart.FetchProducts.Response) {
            presentProductViewModel = response
        }
        
        func removedProduct(response: Cart.RemoveProduct.Response) {
            removeProductViewModel = response
        }
    }
    
    class CartWorkerSpy: CartWorker{
        // MARK: Method call expectations
        var fetchProductCalled = false
        var removeProductCalled = false

        // MARK: Spied methods
        override func fetchAll(completionHandler: @escaping CartStoreFetchProductsCompletionHandler) {
            fetchProductCalled = true
            completionHandler(.success(result:MockData.Products.memStore))
        }
        
        override func removeProduct(productId: String, completionHandler: @escaping CartStoreRemoveProductCompletionHandler) {
            removeProductCalled = true
            completionHandler(.success(result:true))
        }
    }
    
    class CartWorkerFailedSpy: CartWorker{
        // MARK: Method call expectations
        var fetchProductCalled = false
        var removeProductCalled = false
        
        // MARK: Spied methods
        override func fetchAll(completionHandler: @escaping CartStoreFetchProductsCompletionHandler) {
            fetchProductCalled = true
            completionHandler(.failure(error :CartStoreError.CannotFetch("Can't fetch")))
        }
        
        override func removeProduct(productId: String, completionHandler: @escaping CartStoreRemoveProductCompletionHandler) {
            removeProductCalled = true
            completionHandler(.failure(error :CartStoreError.CannotDelete("Can't delete")))
        }
    }
    
    
    // MARK: - Tests
    func test_fetch_products_ask_worker_and_provide_result_to_presenter() {
        // Given
        let cartPresentationLogicSpy = CartPresentationLogicSpy()
        sut.presenter = cartPresentationLogicSpy
        let cartWorkerSpy = CartWorkerSpy(cartStore: CartCoreDataStore())
        sut.worker = cartWorkerSpy
    
        // When
        let request = Cart.FetchProducts.Request()
        sut.fetchProducts(request: request)
        
        // Then
        XCTAssert(cartWorkerSpy.fetchProductCalled, "fetchProducts() should ask worker to fetch products")
        XCTAssertNotNil(cartPresentationLogicSpy.presentProductViewModel, "fetchProducts() should provided result")
        XCTAssertNotNil(cartPresentationLogicSpy.presentProductViewModel!.products, "fetchProducts() should provide products")
        XCTAssert(cartPresentationLogicSpy.presentProductViewModel!.products?.count == MockData.Products.memStore.count, "fetchProducts() should provide exact product")
    }
    
    func test_fetch_products_ask_worker_faiture_from_worker_and_provide_result_to_presenter() {
        // Given
        let cartPresentationLogicSpy = CartPresentationLogicSpy()
        sut.presenter = cartPresentationLogicSpy
        let cartWorkerSpy = CartWorkerFailedSpy(cartStore: CartCoreDataStore())
        sut.worker = cartWorkerSpy
        
        // When
        let request = Cart.FetchProducts.Request()
        sut.fetchProducts(request: request)
        
        // Then
        XCTAssert(cartWorkerSpy.fetchProductCalled, "fetchProducts() should ask worker to fetch products")
        XCTAssertNotNil(cartPresentationLogicSpy.presentProductViewModel, "fetchProducts() should provided result")
        XCTAssertNil(cartPresentationLogicSpy.presentProductViewModel!.products, "fetchProducts() should not provide products")
        XCTAssertNotNil(cartPresentationLogicSpy.presentProductViewModel!.error, "fetchProducts() should provide error")
        XCTAssert(cartPresentationLogicSpy.presentProductViewModel!.error! == MockData.Products.cantFetch, "fetchProducts() should provide cant fetch")
    }
    
    
    func test_remove_products_ask_worker_and_provide_result_to_presenter() {
        // Given
        let cartPresentationLogicSpy = CartPresentationLogicSpy()
        sut.presenter = cartPresentationLogicSpy
        let cartWorkerSpy = CartWorkerSpy(cartStore: CartCoreDataStore())
        sut.worker = cartWorkerSpy
        let productId = MockData.Products.oven.id
        
        // When
        let request = Cart.RemoveProduct.Request(id: productId)
        sut.removeFromCart(request: request)
        
        // Then
        XCTAssert(cartWorkerSpy.removeProductCalled, "removeFromCart() should ask worker to fetch products")
        XCTAssertNotNil(cartPresentationLogicSpy.removeProductViewModel, "removeFromCart() should provided result")
        XCTAssertNotNil(cartPresentationLogicSpy.removeProductViewModel!.success, "removeFromCart() should provide products")
        XCTAssert(cartPresentationLogicSpy.removeProductViewModel!.success!, "removeFromCart() should provide exact product")
    }
    
    func test_remove_products_ask_worker_and_woker_fails_and_provide_result_to_presenter() {
        // Given
        let cartPresentationLogicSpy = CartPresentationLogicSpy()
        sut.presenter = cartPresentationLogicSpy
        let cartWorkerSpy = CartWorkerFailedSpy(cartStore: CartCoreDataStore())
        sut.worker = cartWorkerSpy
        let productId = MockData.Products.oven.id
        
        // When
        let request = Cart.RemoveProduct.Request(id: productId)
        sut.removeFromCart(request: request)
        
        // Then
        XCTAssert(cartWorkerSpy.removeProductCalled, "removeFromCart() should ask worker to fetch products")
        XCTAssertNotNil(cartPresentationLogicSpy.removeProductViewModel, "removeFromCart() should provided result")
        XCTAssertNil(cartPresentationLogicSpy.removeProductViewModel!.success, "removeFromCart() should not provide success")
        XCTAssertNotNil(cartPresentationLogicSpy.removeProductViewModel!.error, "removeFromCart() should provide exact error")
        XCTAssert(cartPresentationLogicSpy.removeProductViewModel!.error! == MockData.Products.cantDelete, "removeFromCart() should provide exact error")
    }
    
}
