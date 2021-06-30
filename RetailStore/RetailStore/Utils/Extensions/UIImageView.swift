//
//  UIImage.swift
//  RetailStore
//
//  Created by Rahul Mane on 21/07/18.
//  Copyright © 2018 developer. All rights reserved.
//

import UIKit

extension UIImageView {
    func setURL(_ imgURLString: String?) {
        guard let imageURLString = imgURLString,let url = URL(string: imageURLString) else {
            self.image = UIImage(named: "Default")
            return
        }
        
        if let cachedImage = ImageCache.shared.image(forKey: imageURLString) {
            self.image = cachedImage
            return
        }
    
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else{
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data){
                    UIView.transition(with: self,
                                      duration:0.5,
                                      options: .transitionCrossDissolve,
                                      animations: { self.image = image },
                                      completion: nil)
                    ImageCache.shared.set(image, forKey: imageURLString)
                }
                else{
                    self.image = UIImage(named: "Default")
                }
            }
        }
    }
}
