//
//  ShowProductInteractorTests.swift
//  RetailStoreTests
//
//  Created by Rahul Mane on 23/07/18.
//  Copyright © 2018 developer. All rights reserved.
//

import XCTest
@testable import RetailStore

class ShowProductInteractorTests: XCTestCase {
    var sut : ShowProductInteractor!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ShowProductInteractor()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Test doubles
    class ShowProductPresentationLogicSpy: ShowProductPresentationLogic{
        // MARK: Method call expectations
        var presentProductCalled = false
        var presentSaveProductCalled = false

        var addToCartViewModel : ShowProduct.AddToCart.Response?
        var receivedProduct : Product?
        func presentProduct(response: ShowProduct.Fetch.Response) {
            presentProductCalled = true
            receivedProduct = response.product
        }
        
        func savedProduct(response: ShowProduct.AddToCart.Response) {
            presentSaveProductCalled = true
            addToCartViewModel = response
        }
    }
    
    class ShowProductWorkerSpy: ShowProductWorker{
        // MARK: Method call expectations
        var addToCartCalled = false
        var isExpectedResponse = false
        override func addToCart(product: Product, completionHandler: @escaping CartStoreAddProductCompletionHandler) {
            addToCartCalled = true
            
            completionHandler(.success(result : product))
        }
    }
    
    class ShowProductWorkerFailedSpy: ShowProductWorker{
        // MARK: Method call expectations
        var addToCartCalled = false
        var isExpectedResponse = false
        
        override func addToCart(product: Product, completionHandler: @escaping CartStoreAddProductCompletionHandler) {
            addToCartCalled = true
            
            completionHandler(.failure(error : CartStoreError.CannotCreate("Can't create")))
        }
    }
    
    //MARK: Tests
    func test_show_product_should_update_presenter(){
        // Given
        let showProductPresentationLogicSpy = ShowProductPresentationLogicSpy()
        sut.presenter = showProductPresentationLogicSpy
        let showProductWorkerSpy = ShowProductWorkerSpy(cartStore: CartCoreDataStore())
        sut.worker = showProductWorkerSpy
        sut.product = MockData.Products.oven
        
        // When
        let request = ShowProduct.Fetch.Request()
        sut.fetchProduct(request: request)
        
        // Then
        XCTAssert(showProductPresentationLogicSpy.presentProductCalled, "fetchProduct() should ask presenter to format products result")
        XCTAssertNotNil(showProductPresentationLogicSpy.receivedProduct, "fetchProducts() should not be nil")
        XCTAssert(showProductPresentationLogicSpy.receivedProduct == MockData.Products.oven, "fetchProducts() should provide correct product")
    }
    
    func test_show_product_should_add_product_to_cart_and_ask_presenter(){
        // Given
        let showProductPresentationLogicSpy = ShowProductPresentationLogicSpy()
        sut.presenter = showProductPresentationLogicSpy
        let showProductWorkerSpy = ShowProductWorkerSpy(cartStore: CartCoreDataStore())
        sut.worker = showProductWorkerSpy
        sut.product = MockData.Products.oven
        
        // When
        let request = ShowProduct.AddToCart.Request()
        sut.addToCart(request: request)

        //then
        XCTAssert(showProductWorkerSpy.addToCartCalled, "addToCart() should ask worker to add product to cart")
        XCTAssert(showProductPresentationLogicSpy.presentSaveProductCalled, "addToCart() should ask notify to presenter that product is added to cart")
        XCTAssertNotNil(showProductPresentationLogicSpy.addToCartViewModel, "addToCart() should ask notify to presenter that product is added to cart")
        XCTAssertNotNil(showProductPresentationLogicSpy.addToCartViewModel!.product, "addToCart() should provided exptect product")
        XCTAssert(showProductPresentationLogicSpy.addToCartViewModel!.product! == MockData.Products.oven, "addToCart() should provided exptect product")

    }
    
    
    func test_show_product_should_not_add_product_to_cart_if_product_nil(){
        // Given
        let showProductPresentationLogicSpy = ShowProductPresentationLogicSpy()
        sut.presenter = showProductPresentationLogicSpy
        let showProductWorkerSpy = ShowProductWorkerFailedSpy(cartStore: CartCoreDataStore())
        sut.worker = showProductWorkerSpy
        
        // When
        let request = ShowProduct.AddToCart.Request()
        sut.addToCart(request: request)
        
        //then
        XCTAssert(!showProductWorkerSpy.addToCartCalled, "addToCart() should ask worker to add product to cart")
        XCTAssert(!showProductPresentationLogicSpy.presentSaveProductCalled, "addToCart() should not ask notify to presenter that product is added to cart")        
    }
    
    func test_show_product_should_not_add_product_to_cart_if_worker_failed_add_it(){
        // Given
        let showProductPresentationLogicSpy = ShowProductPresentationLogicSpy()
        sut.presenter = showProductPresentationLogicSpy
        let showProductWorkerSpy = ShowProductWorkerFailedSpy(cartStore: CartCoreDataStore())
        sut.worker = showProductWorkerSpy
        sut.product = MockData.Products.oven

        // When
        let request = ShowProduct.AddToCart.Request()
        sut.addToCart(request: request)
        
        //then
        XCTAssert(showProductWorkerSpy.addToCartCalled, "addToCart() should ask worker to add product to cart")
        XCTAssert(showProductPresentationLogicSpy.presentSaveProductCalled, "addToCart() should ask notify to presenter that product is added to cart")
        XCTAssertNotNil(showProductPresentationLogicSpy.addToCartViewModel, "addToCart() should ask notify to presenter that product is added to cart")
        XCTAssertNotNil(showProductPresentationLogicSpy.addToCartViewModel!.error, "addToCart() should provided exptect product")
        XCTAssert(showProductPresentationLogicSpy.addToCartViewModel!.error! == MockData.Products.cantCreate, "addToCart() should provided expected error")
    }
}
