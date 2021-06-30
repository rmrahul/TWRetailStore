//
//  CartsCoreDataStoreTests.swift
//  RetailStoreTests
//
//  Created by Rahul Mane on 23/07/18.
//  Copyright © 2018 developer. All rights reserved.
//

import XCTest
import CoreData
@testable import RetailStore

class CartsCoreDataStoreTests: XCTestCase {
    //MARK: Subject under test
    var sut : CartCoreDataStore!
    var stubbedProducts : [Product]!
    var saveNotificationCompleteHandler: ((Notification)->())?

    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))])!
        return managedObjectModel
    }()
    
    lazy var mockPersistantContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PersistantRetailStore", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
            
            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()
    
    override func setUp() {
        super.setUp()
        initSubProducts()
        sut = CartCoreDataStore(container: mockPersistantContainer)
        
        NotificationCenter.default.addObserver( self,
                                                selector: #selector(contextSaved(notification:)),
                                                name: NSNotification.Name.NSManagedObjectContextDidSave ,
                                                object: nil )
    }
    
    override func tearDown() {
        flushData() // Clear all stubs
        super.tearDown()
    }
    
    //MARK: Mocking
    func contextSaved( notification: Notification ) {
         saveNotificationCompleteHandler?(notification)
    }
    
    func waitForSavedNotification(completeHandler: @escaping ((Notification)->()) ) {
        saveNotificationCompleteHandler = completeHandler
    }
    
    func initSubProducts(){
        func insert(product : Product){
            guard  let managedProduct = NSEntityDescription.insertNewObject(forEntityName: "ManagedProduct", into: mockPersistantContainer.viewContext) as? ManagedProduct else {
                //log error
                return
            }
            managedProduct.fromProduct(product: product)
        }
        
        stubbedProducts = []
        for index in 1...5{
            let product = Product(id: "\(index)", name: "Product \(index)", price: Double(index), category: "Category \(index)", images: ["URL\(index)1","URL\(index)2"])
            
            insert(product: product)
            stubbedProducts.append(product)
        }
        
        do {
            try mockPersistantContainer.viewContext.save()
        }  catch {
            print("create fakes error \(error)")
        }
    }

    func flushData() {
        let request = ManagedProduct.productFetchRequest()
        let objs = try! mockPersistantContainer.viewContext.fetch(request)
        for case let obj as NSManagedObject in objs {
            mockPersistantContainer.viewContext.delete(obj)
        }
        try! mockPersistantContainer.viewContext.save()
    }
    
    //MARK: Tests
    func test_fetch_products(){
        //given
        
        //when
        let expect = expectation(description: "Wait for fetchproducts() to return")
        var fetchedProducts : [Product] = []
        var fetchedError : CartStoreError?
        
        sut.fetchAll{ (result) in
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
        XCTAssertEqual(fetchedProducts.count, stubbedProducts.count,"fetchAll() should return all objects")
        for p in fetchedProducts{
            XCTAssert(stubbedProducts.contains(where: { $0 == p }),"fetchAll() should match the products in the data store")
        }
        XCTAssertNil(fetchedError, "fetchAll() should not return an error")
    }
    
    func test_fetch_product_should_return_product(){
        //given
        let testOrder = stubbedProducts.first
        
        //when
        let expect = expectation(description: "Wait for fetch() to return")
        var fetchedOrder : Product?
        var fetchedError : CartStoreError?
        
        sut.fetch(productId: (testOrder?.id)!) { (result) in
            switch(result){
            case .success(let p):
                fetchedOrder = p
                break
            case .failure(let error):
                fetchedError = error
            }
            expect.fulfill()
        }
        waitForExpectations(timeout: 1.0)

        //then
        XCTAssertNotNil(fetchedOrder,"fetch() should not return nil value")
        XCTAssert(fetchedOrder! == testOrder!, "fetch() should return exact product")
        XCTAssertNil(fetchedError, "fetch() should not return an error")
    }
    
    func test_fetch_product_should_return_error(){
        //given
        let randomProductId = "123"
        
        //when
        let expect = expectation(description: "Wait for fetch() to return")
        var fetchedOrder : Product?
        var fetchedError : CartStoreError?
        
        sut.fetch(productId: randomProductId) { (result) in
            switch(result){
            case .success(let p):
                fetchedOrder = p
                break
            case .failure(let error):
                fetchedError = error
            }
            expect.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        
        //then
        XCTAssertNil(fetchedOrder,"fetch() should return nil value")
        XCTAssertNotNil(fetchedError, "fetch() should return an error")
        XCTAssert(fetchedError == CartStoreError.CannotFetch("Can't fetch"),"fetch() should return an error")
    }
    
    func test_add_product_should_return_product(){
        //given
        let oven = MockData.Products.oven
        
        //when
        let contextSaveExpect = expectation(description: "Context Saved")
        waitForSavedNotification { (notification) in
            contextSaveExpect.fulfill()
        }
        
        let expect = expectation(description: "Wait for add() to return")
        var fetchedOrder : Product?
        var fetchedError : CartStoreError?
        
        sut.add(product: oven) { (result) in
            switch(result){
            case .success(let p):
                fetchedOrder = p
                break
            case .failure(let error):
                fetchedError = error
            }
            expect.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        
        //then
        XCTAssertNotNil(fetchedOrder,"add() should not return nil value")
        XCTAssertNil(fetchedError, "add() should not return an error")
        XCTAssert(fetchedOrder! == oven, "add() should add oven product")
    }
    
    func test_update_product_should_return_updated_product(){
        //given
        var firstProduct = stubbedProducts.first!
        firstProduct.count = 100
        
        //when
        let expect = expectation(description: "Wait for update() to return")
        var fetchedOrder : Product?
        var fetchedError : CartStoreError?
        
        sut.update(product: firstProduct) { (result) in
            switch(result){
            case .success(let p):
                fetchedOrder = p
                break
            case .failure(let error):
                fetchedError = error
            }
            expect.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        
        //then
        XCTAssertNotNil(fetchedOrder,"add() should not return nil value")
        XCTAssertNil(fetchedError, "add() should not return an error")
        XCTAssert(fetchedOrder! == firstProduct, "add() should add oven product")
    }
    
    func test_update_product_should_return_error(){
        //given
        var firstProduct = stubbedProducts.first!
        firstProduct.count = 100
        firstProduct.id = "Some_UNKNOWN_Id"
        
        //when
        let expect = expectation(description: "Wait for update() to return")
        var fetchedOrder : Product?
        var fetchedError : CartStoreError?
        
        sut.update(product: firstProduct) { (result) in
            switch(result){
            case .success(let p):
                fetchedOrder = p
                break
            case .failure(let error):
                fetchedError = error
            }
            expect.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        
        //then
        XCTAssertNil(fetchedOrder,"update() should not return nil value")
        XCTAssertNotNil(fetchedError, "update() should not return an error")
        XCTAssert(fetchedError == CartStoreError.CannotUpdate("Can't update"),"fetch() should return an error")
    }
    
    func test_remove_product_from_cart_should_return_true(){
        //given
        let firstProduct = stubbedProducts.first!

        //when
        let expect = expectation(description: "Wait for delete() to return")
        var isSuccess : Bool?
        var fetchedError : CartStoreError?
        
        sut.remove(productId: firstProduct.id) { (result) in
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
        
        //then
        XCTAssertNotNil(isSuccess,"delete() should not return nil value")
        XCTAssertNil(fetchedError, "delete() should not return an error")
        XCTAssert(isSuccess!,"delete() should return true")
    }
    
    func test_remove_product_from_cart_should_return_false(){
        //given
        let randomId = "SOME_UNKNOWN_RANDOM_ID"
        
        //when
        let expect = expectation(description: "Wait for delete() to return")
        var isSuccess : Bool?
        var fetchedError : CartStoreError?
        
        sut.remove(productId: randomId) { (result) in
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
        
        //then
        XCTAssertNil(isSuccess,"delete() should not return nil value")
        XCTAssertNotNil(fetchedError, "delete() should not return an error")
        XCTAssert(fetchedError == CartStoreError.CannotDelete("Can't delete"),"delete() should return an error")
    }
}
