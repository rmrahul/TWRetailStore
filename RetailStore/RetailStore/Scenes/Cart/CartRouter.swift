//
//  CartRouter.swift
//  RetailStore
//
//  Created by Rahul Mane on 21/07/18.
//  Copyright (c) 2018 developer. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol CartRoutingLogic{
    func routeToShowProduct(indexPath : IndexPath)
}

protocol CartDataPassing{
    var dataStore: CartDataStore? { get }
}

class CartRouter: NSObject, CartRoutingLogic, CartDataPassing{
    weak var viewController: CartViewController?
    var dataStore: CartDataStore?
    
    // MARK: Routing
    func routeToShowProduct(indexPath : IndexPath){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "ShowProductViewController") as! ShowProductViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToShowProduct(source: dataStore!, destination: &destinationDS,selectedIndex:indexPath)
        navigateToShowProduct(source: viewController!, destination: destinationVC)
    }
    
    // MARK: Navigation
    private func navigateToShowProduct(source: CartViewController, destination: ShowProductViewController){
        source.show(destination, sender: nil)
    }
    
    // MARK: Passing data
    private func passDataToShowProduct(source: CartDataStore, destination: inout ShowProductDataStore,selectedIndex : IndexPath){
        destination.product = source.products?[selectedIndex.row]
        destination.usedBy = .cart
    }
}