//
//  CartPresenterTests.swift
//  RetailStoreTests
//
//  Created by Rahul Mane on 23/07/18.
//  Copyright © 2018 developer. All rights reserved.
//

import XCTest
@testable import RetailStore

class CartPresenterTests: XCTestCase {
    // MARK: - Subject under test
    var sut: CartPresenter!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = CartPresenter()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Test doubles
    class CartDisplayLogicSpy: CartDisplayLogic{
        // MARK: Argument expectations
        var fetchCartSuccessViewModel: Cart.FetchProducts.ProductViewModel?
        var fetchCartErrorViewModel : Cart.FetchProducts.ErrorViewModel?
        var removeCartSuccessViewModel: Cart.RemoveProduct.ProductViewModel?
        var removeCartErrorViewModel : Cart.RemoveProduct.ErrorViewModel?
        
        // MARK: Spied methods
        func displayProducts(viewModel: Cart.FetchProducts.ProductViewModel){
            fetchCartSuccessViewModel = viewModel
        }
        
        func displayError(viewModel: Cart.FetchProducts.ErrorViewModel){
            fetchCartErrorViewModel = viewModel

        }
        
        func removedFromCart(viewModel: Cart.RemoveProduct.ProductViewModel){
            removeCartSuccessViewModel = viewModel

        }
        
        func displayError(viewModel: Cart.RemoveProduct.ErrorViewModel){
            removeCartErrorViewModel = viewModel
        }
    }
    
    
    func test_present_fetched_products_should_show_success(){
        // Given
        let cartDisplayLogicSpy = CartDisplayLogicSpy()
        sut.viewController = cartDisplayLogicSpy
        let resultOfInteractor = MockData.Products.memStore

        //when
        let response = Cart.FetchProducts.Response(products: resultOfInteractor, error: nil)
        sut.presentProducts(response: response)
        
        // Then
        let displayedProducts = cartDisplayLogicSpy.fetchCartSuccessViewModel
        
        XCTAssertNotNil(displayedProducts, "presentProducts() should return products")
        XCTAssertNotNil(displayedProducts!.displayedProducts, "presentProducts() should return products")
        XCTAssert(MockData.Products.memStore.count == displayedProducts!.displayedProducts.count, "presentProducts() should return exact objects")
        XCTAssert(displayedProducts!.total == MockData.Products.memStoreTotalAmount, "presentProducts() should calculate total correctly")
    }
    
    func test_present_fetched_products_should_show_failure(){
        // Given
        let cartDisplayLogicSpy = CartDisplayLogicSpy()
        sut.viewController = cartDisplayLogicSpy
        
        //when
        let response = Cart.FetchProducts.Response(products: nil, error: CartStoreError.CannotFetch("Can't fetch"))
        sut.presentProducts(response: response)
        
        // Then
        let errorModel = cartDisplayLogicSpy.fetchCartErrorViewModel
        XCTAssertNotNil(errorModel, "presentProducts() should return errormodel")
    }
    
    func test_remove_product_cart_should_show_success(){
        // Given
        let cartDisplayLogicSpy = CartDisplayLogicSpy()
        sut.viewController = cartDisplayLogicSpy
        
        //when
        let response = Cart.RemoveProduct.Response(success: true, error: nil)
        sut.removedProduct(response: response)
        
        // Then
        let removeCartModel = cartDisplayLogicSpy.removeCartSuccessViewModel
        
        XCTAssertNotNil(removeCartModel, "removedProduct() should return view model")
        XCTAssertNotNil(removeCartModel?.success, "removedProduct() should return success value")
        XCTAssert(removeCartModel!.success!, "removedProduct() should return true")
        
    }
    
    func test_remove_product_cart_should_show_failure(){
        // Given
        let cartDisplayLogicSpy = CartDisplayLogicSpy()
        sut.viewController = cartDisplayLogicSpy
        
        //when
        let response = Cart.RemoveProduct.Response(success: nil, error: CartStoreError.CannotDelete("Can't delete"))
        sut.removedProduct(response: response)
        
        // Then
        let removeCartModel = cartDisplayLogicSpy.removeCartErrorViewModel

        XCTAssertNotNil(removeCartModel, "removedProduct() should return view model")
    }
}
