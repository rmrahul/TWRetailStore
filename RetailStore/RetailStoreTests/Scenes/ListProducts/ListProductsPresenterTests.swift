//
//  ListProductsPresentorTests.swift
//  RetailStoreTests
//
//  Created by Rahul Mane on 23/07/18.
//  Copyright © 2018 developer. All rights reserved.
//

import XCTest
@testable import RetailStore

class ListProductsPresenterTests: XCTestCase {
    // MARK: - Subject under test
    var sut: ListProductsPresenter!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ListProductsPresenter()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Test doubles
    class ListProductsDisplayLogicSpy: ListProductsDisplayLogic{
        // MARK: Method call expectations
        var displayFetchedProductsCalled = false
        var displayFetchedProductsErrorCalled = false
        
        // MARK: Argument expectations
        var viewModel: ListProducts.Fetch.ProductViewModel!
        var errorModel : ListProducts.Fetch.ErrorViewModel!
        
        // MARK: Spied methods
        func displayProducts(viewModel: ListProducts.Fetch.ProductViewModel){
            displayFetchedProductsCalled = true
            self.viewModel = viewModel
        }
        
        func displayError(viewModel: ListProducts.Fetch.ErrorViewModel){
            displayFetchedProductsErrorCalled = true
            errorModel = viewModel
        }
    }
    
    // MARK: - Tests
    func test_present_fetched_products_should_show_success(){
        // Given
        let listProductsDisplayLogicSpy = ListProductsDisplayLogicSpy()
        sut.viewController = listProductsDisplayLogicSpy
        let resultOfInteractor = MockData.Products.memStoreFiltered

        //when        
        let response = ListProducts.Fetch.Response(products: resultOfInteractor, error: nil)
        sut.presentProducts(response: response)
        
        // Then
        let displayedProducts = listProductsDisplayLogicSpy.viewModel.displayedProducts
        
        XCTAssert(MockData.Products.memStoreFiltered.count == displayedProducts.count, "presentProducts() should return exact filtered object")
    }
    
    func test_present_fetched_products_should_show_failure(){
        // Given
        let listProductsDisplayLogicSpy = ListProductsDisplayLogicSpy()
        sut.viewController = listProductsDisplayLogicSpy
        
        //when
        let response = ListProducts.Fetch.Response(products: nil, error: ProductStoreError.CannotFetch("Can't fetch"))
        sut.presentProducts(response: response)
        
        // Then
        let errorModel = listProductsDisplayLogicSpy.errorModel
        
        XCTAssert(listProductsDisplayLogicSpy.displayFetchedProductsErrorCalled, "presentProducts() should return call display error")
        XCTAssertNotNil(errorModel, "presentProducts error view model should not be null")
    }
    
    func test_present_fetched_products_should_show_failure_if_error_nil(){
        // Given
        let listProductsDisplayLogicSpy = ListProductsDisplayLogicSpy()
        sut.viewController = listProductsDisplayLogicSpy
        
        //when
        let response = ListProducts.Fetch.Response(products: nil, error: nil)
        sut.presentProducts(response: response)
        
        // Then
        let errorModel = listProductsDisplayLogicSpy.errorModel
        
        XCTAssert(listProductsDisplayLogicSpy.displayFetchedProductsErrorCalled, "presentProducts() should return call display error")
        XCTAssertNotNil(errorModel, "presentProducts error view model should not be null")
    }
    
    func test_present_fetched_products_should_show_failure_if_unhandled_error(){
        // Given
        let listProductsDisplayLogicSpy = ListProductsDisplayLogicSpy()
        sut.viewController = listProductsDisplayLogicSpy
        
        //when
        let response = ListProducts.Fetch.Response(products: nil, error: ProductStoreError.CannotCreate("Can't create"))
        sut.presentProducts(response: response)
        
        // Then
        let errorModel = listProductsDisplayLogicSpy.errorModel
        
        XCTAssert(listProductsDisplayLogicSpy.displayFetchedProductsErrorCalled, "presentProducts() should return call display error")
        XCTAssertNotNil(errorModel, "presentProducts error view model should not be null")
        XCTAssert(!(errorModel!.message.contains("Something went wrong")), "presentProducts error view model should handle unknow error")
    }
}
