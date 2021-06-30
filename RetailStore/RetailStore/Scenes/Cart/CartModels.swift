//
//  CartModels.swift
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

enum Cart{
    // MARK: Use cases
    struct Request{}
    struct Response{}
    struct ViewModel{
        struct DisplayedProduct{
            var id: String
            var name: NSAttributedString
            var category: NSAttributedString
            var price: NSAttributedString
            var image: String
            var count: NSAttributedString
            var subtotal: NSAttributedString
            var priceValue : Double
            var countValue : Int
        }
    }
    
    
    enum FetchProducts{
        struct Request{}
        
        struct Response{
            var products : [Product]?
            var error : CartStoreError?
        }
        
        struct ProductViewModel{
            var displayedProducts : [Cart.ViewModel.DisplayedProduct]
            var total : String{
                let totalAmount = displayedProducts.reduce(0.0, { (sum, product) -> Double in
                    let price = (product.priceValue)
                    let count = Double(product.countValue)
                    return sum + (price * count)
                })
                
                return "\(totalAmount )"
            }
        }
        
        struct ErrorViewModel {
            var title : String
            var message : String
        }
    }
    
    enum RemoveProduct{
        struct Request{
            var id : String
        }
        
        struct Response{
            var success : Bool?
            var error : CartStoreError?
        }
        
        struct ProductViewModel{
            var success : Bool?
            var title : String
            var message : String
        }
        
        struct ErrorViewModel {
            var title : String
            var message : String
        }
    }
}