//
//  CartCoreDataStore.swift
//  RetailStore
//
//  Created by Rahul Mane on 23/07/18.
//  Copyright © 2018 developer. All rights reserved.
//

import UIKit
import CoreData

class CartCoreDataStore: CartStoreProtocol {
    let persistentContainer: NSPersistentContainer!
    let entityName = "ManagedProduct"
    
    //MARK: Init with dependency
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    convenience init() {
        //Use the default container for production environment
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not get shared app delegate")
        }
        self.init(container: appDelegate.persistentContainer)
    }
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    //MARK: CartStoreProtocol
    func add(product: Product, completionHandler: @escaping CartStoreAddProductCompletionHandler) {
        guard  let managedProduct = NSEntityDescription.insertNewObject(forEntityName: entityName, into: backgroundContext) as? ManagedProduct else {
            //log error
            completionHandler(.failure(error: CartStoreError.CannotCreate("Can't saved")))
            return
        }
        managedProduct.fromProduct(product: product)
        save()
        completionHandler(.success(result:managedProduct.toProduct()))
    }
    
    func update(product : Product,completionHandler:@escaping CartStoreUpdateProductCompletionHandler){
        guard let managedObject = fetchProduct(productId: product.id)?.first else {
            completionHandler(.failure(error: CartStoreError.CannotUpdate("Can't update")))
            return
        }
        managedObject.fromProduct(product: product)
        save()
        completionHandler(.success(result:managedObject.toProduct()))
    }
    
    func fetchAll(completionHandler: @escaping CartStoreFetchProductsCompletionHandler) {
        let request : NSFetchRequest<ManagedProduct> = ManagedProduct.productFetchRequest()
        guard let managedProducts = try? persistentContainer.viewContext.fetch(request) as [ManagedProduct] else{
            completionHandler(.failure(error: CartStoreError.CannotFetch("Can't fetch")))
            return
        }
        
        let products : [Product] = managedProducts.map({ (mProduct) -> Product in
            mProduct.toProduct()
        })
        completionHandler(.success(result : products))
    }
    
    func remove(productId: String, completionHandler: @escaping CartStoreRemoveProductCompletionHandler) {
        guard let objToDelete = fetchProduct(productId: productId)?.first else{
            completionHandler(.failure(error: CartStoreError.CannotDelete("Can't delete")))
            return
        }
        persistentContainer.viewContext.delete(objToDelete)
        saveViewContext()
        completionHandler(.success(result: true))
    }
    
    func fetch(productId : String,completionHandler:@escaping CartStoreFetchProductCompletionHandler){
        guard let managedObject = fetchProduct(productId: productId)?.first else {
            completionHandler(.failure(error: CartStoreError.CannotFetch("Can't fetch")))
            return
        }
        completionHandler(.success(result : managedObject.toProduct()))
    }
    
    //MARK: Privates
    private func fetchProduct(productId : String) -> [ManagedProduct]?{
        let request : NSFetchRequest<ManagedProduct> = ManagedProduct.productFetchRequest()
        request.predicate  = NSPredicate(format: "id == %@", productId)
        return try? persistentContainer.viewContext.fetch(request) as [ManagedProduct]
    }

    private func save() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                //log error
                print("Save error \(error)")
            }
        }
    }
    
    private func saveViewContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                //log error
                print("Save error \(error)")
            }
        }
    }
}
