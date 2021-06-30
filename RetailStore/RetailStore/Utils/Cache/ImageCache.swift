//
//  ImageCache.swift
//  RetailStore
//
//  Created by Rahul Mane on 21/07/18.
//  Copyright © 2018 developer. All rights reserved.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()
    private var images = [String:UIImage]()
    
    private init() {
        NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationDidReceiveMemoryWarning, object: nil, queue: .main) { [weak self] notification in
            self?.images.removeAll(keepingCapacity: false)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func set(_ image: UIImage, forKey key: String) {
        images[key] = image
    }
    
    func image(forKey key: String) -> UIImage? {
        return images[key]
    }
}

