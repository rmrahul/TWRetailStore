//
//  ProductsMemStore.swift
//  RetailStore
//
//  Created by Rahul Mane on 21/07/18.
//  Copyright © 2018 developer. All rights reserved.
//

import UIKit

class ProductsMemStore: ProductStoreProtocol {
   
    //dummy products
    static var products = [
        Product(id: "12", name: "Microwave oven", price: 5400, category: "Electronics",images:["https://5.imimg.com/data5/BK/PH/MY-17549931/microwave-oven-500x500.jpg"]),
        Product(id: "13", name: "Television", price: 13000, category: "Electronics",images:["https://www.superprice.com/pub/media/catalog/product/cache/image/600x600/e9c3970ab036de70892d86c6d221abfe/s/a/samsung_24_inch_led_hd_digital_monitor_television_te_310_base.jpg"]),
        Product(id: "14", name: "Vacuum Cleaner", price: 7499, category: "Electronics",images:["https://ii1.pepperfry.com/media/catalog/product/e/u/800x880/eureka-forbes-trendy-wet---dry-dx-canister-1150-w-vacuum-cleaner-eureka-forbes-trendy-wet---dry-dx-c-3zlp3w.jpg"]),
        Product(id: "15", name: "Television", price: 11999, category: "Electronics",images:["http://www.kara.com.ng/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/l/g/lg_led_television_22_mt48a_1.jpg"]),
        Product(id: "16", name: "Television", price: 12299, category: "Electronics",images:["https://4.imimg.com/data4/CF/VV/MY-23364860/panache-40-led-television-500x500.jpg"]),
        Product(id: "17", name: "Table", price: 1900, category: "Furniture",images:["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBUXvsRSrFdTzPDe8CcoOq0-CGFQSeFrhOqk_Z4dSRgObIs33R"]),
        Product(id: "18", name: "Chair", price: 1299, category: "Furniture",images:["https://www.ikea.com/PIAimages/0355482_PE547815_S5.JPG"]),
        Product(id: "19", name: "Table", price: 2499, category: "Furniture",images:["https://images.crateandbarrel.com/is/image/Crate/RegattaRectDiningTableSHS16_16x9/?$web_zoom_furn_hero$&160329154029&wid=1008&hei=567"]),
        Product(id: "20", name: "Chair", price: 999, category: "Furniture",images:["https://www.ikea.com/us/en/images/products/ekedalen-chair-brown__0516603_PE640439_S4.JPG"]),
        Product(id: "21", name: "Almirah", price: 18990, category: "Furniture",images:["https://5.imimg.com/data5/FP/GP/MY-5017441/wooden-almirah-500x500.jpg"]),
    ]

    //MARK: ProductStoreProtocol implementation
    func fetch(completionHandler: @escaping ProductsStoreFetchProductsCompletionHandler) {
        completionHandler(.success(result: ProductsMemStore.products))
    }
}
