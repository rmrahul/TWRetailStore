//
//  ShowProductPresenterTests.swift
//  RetailStoreTests
//
//  Created by Rahul Mane on 23/07/18.
//  Copyright © 2018 developer. All rights reserved.
//

import XCTest
@testable import RetailStore

class ShowProductPresenterTests: XCTestCase {
    // MARK: - Subject under test
    var sut: ShowProductPresenter!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ShowProductPresenter()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Test doubles
    class ShowProductDisplayLogicSpy: ShowProductDisplayLogic{
        // MARK: Method call expectations
        var displayProductCalled = false
        var displaySuccessOfAddCartCalled = false
        var displayErrorForFetchCalled = false
        var displayErrorForAddCartCalled = false
        
        // MARK: Argument expectations
        var presentedProductViewModel: ShowProduct.Fetch.DisplayedProductViewModel!
        var fetchErrorModel : ShowProduct.Fetch.ErrorViewModel?
        var cartErrorModel : ShowProduct.AddToCart.ErrorViewModel?
        
        // MARK: Spied methods
        func displayProduct(viewModel: ShowProduct.Fetch.DisplayedProductViewModel) {
            displayProductCalled = true
            presentedProductViewModel = viewModel
        }
        
        func displaySuccessOfAddCart(viewModel: ShowProduct.AddToCart.DisplayedProductViewModel) {
            displaySuccessOfAddCartCalled = true
        }
        
        func displayError(viewModel: ShowProduct.Fetch.ErrorViewModel) {
            displayErrorForFetchCalled = true
            fetchErrorModel = viewModel
        }
        
        func displayError(viewModel: ShowProduct.AddToCart.ErrorViewModel) {
            displayErrorForAddCartCalled = true
            cartErrorModel = viewModel
        }
    }
    
    //MARK: Tests
    
    func test_present_product_from_cart_should_show_success(){
        // Given
        let showProductDisplayLogicSpy = ShowProductDisplayLogicSpy()
        sut.viewController = showProductDisplayLogicSpy
        let resultOfInteractor = MockData.Products.oven
        
        //when
        let response = ShowProduct.Fetch.Response(product: resultOfInteractor, usedBy: ShowProduct.ShowProductUsedBy.cart)
        sut.presentProduct(response: response)
        
        // Then
        let displayedProducts = showProductDisplayLogicSpy.presentedProductViewModel.tableRepresentation
        
        XCTAssertNotNil(displayedProducts, "presentProduct() should provide result")
        XCTAssert(showProductDisplayLogicSpy.presentedProductViewModel.id == MockData.Products.oven.id, "presentProducts() should return oven object")
        XCTAssert(displayedProducts.count == 3, "presentProducts() should return 3 rows if product is seeing from cart")
    }
    
    func test_present_product_from_products_list_should_show_success(){
        // Given
        let showProductDisplayLogicSpy = ShowProductDisplayLogicSpy()
        sut.viewController = showProductDisplayLogicSpy
        let resultOfInteractor = MockData.Products.oven
        
        //when
        let response = ShowProduct.Fetch.Response(product: resultOfInteractor, usedBy: ShowProduct.ShowProductUsedBy.productList)
        sut.presentProduct(response: response)
        
        // Then
        let displayedProducts = showProductDisplayLogicSpy.presentedProductViewModel.tableRepresentation
        
        XCTAssertNotNil(displayedProducts, "presentProduct() should provide result")
        XCTAssert(showProductDisplayLogicSpy.presentedProductViewModel.id == MockData.Products.oven.id, "presentProducts() should return oven object")
        XCTAssert(displayedProducts.count == 4, "presentProducts() should return 3 rows if product is seeing from cart")
    }
    
    func test_present_product_from_cart_should_show_failure(){
        // Given
        let showProductDisplayLogicSpy = ShowProductDisplayLogicSpy()
        sut.viewController = showProductDisplayLogicSpy
        
        //when
        let response = ShowProduct.Fetch.Response(product: nil, usedBy: ShowProduct.ShowProductUsedBy.cart)
        sut.presentProduct(response: response)
        
        // Then
        XCTAssert(showProductDisplayLogicSpy.displayErrorForFetchCalled, "presentProducts() should call display error")
        XCTAssertNotNil(showProductDisplayLogicSpy.fetchErrorModel, "presentProducts() should return valid error")
    }
    
    func test_present_product_from_products_list_should_show_failure(){
        // Given
        let showProductDisplayLogicSpy = ShowProductDisplayLogicSpy()
        sut.viewController = showProductDisplayLogicSpy
        
        //when
        let response = ShowProduct.Fetch.Response(product: nil, usedBy: ShowProduct.ShowProductUsedBy.productList)
        sut.presentProduct(response: response)
        
        // Then
        XCTAssert(showProductDisplayLogicSpy.displayErrorForFetchCalled, "presentProducts() should call display error")
        XCTAssertNotNil(showProductDisplayLogicSpy.fetchErrorModel, "presentProducts() should return valid error")
    }
    
    
    func test_add_product_cart_from_products_list_should_show_success(){
        // Given
        let showProductDisplayLogicSpy = ShowProductDisplayLogicSpy()
        sut.viewController = showProductDisplayLogicSpy
        let resultOfInteractor = MockData.Products.oven

        //when
        let response = ShowProduct.AddToCart.Response(product: resultOfInteractor, error: nil)
        sut.savedProduct(response: response)
        
        // Then
        XCTAssert(showProductDisplayLogicSpy.displaySuccessOfAddCartCalled, "presentProducts() should call display success")
    }
    
    func test_add_product_cart_from_products_list_should_show_failure(){
        // Given
        let showProductDisplayLogicSpy = ShowProductDisplayLogicSpy()
        sut.viewController = showProductDisplayLogicSpy
        
        //when
        let response = ShowProduct.AddToCart.Response(product: nil, error: CartStoreError.CannotCreate("Can't create"))
        sut.savedProduct(response: response)
        
        // Then
        XCTAssert(showProductDisplayLogicSpy.displayErrorForAddCartCalled, "presentProducts() should call display success")
        XCTAssertNotNil(showProductDisplayLogicSpy.cartErrorModel, "presentProducts() should call display error")
    }
}
