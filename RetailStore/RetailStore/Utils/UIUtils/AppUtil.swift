//
//  UIUtil.swift
//  RetailStore
//
//  Created by Rahul Mane on 22/07/18.
//  Copyright © 2018 developer. All rights reserved.
//

import UIKit
import SwiftMessages

struct AppUtil {
    private init() {}
    
    static func getAttributedString(from title: String, subTitle value : String) -> NSAttributedString {
        let titleAttr = [NSAttributedStringKey.font : AppManager.appStyle.font(for: .title)]
        let attributedString = NSMutableAttributedString(string:title, attributes:titleAttr)
        let valueAttr = [NSAttributedStringKey.font : AppManager.appStyle.font(for: .subtitle)]
        let normalString = NSMutableAttributedString(string:value,attributes:valueAttr)
        attributedString.append(normalString)
        return attributedString
    }
    
    static func showError(title : String, body : String){
        let error = MessageView.viewFromNib(layout: .messageView)
        error.configureTheme(.info)
        error.configureContent(title: title, body: body, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil, buttonTapHandler: nil)
        error.button?.isHidden = true
        
        SwiftMessages.show(view: error)
    }
    
    static func showSuccess(title : String, body : String){
        let successConfig = SwiftMessages.defaultConfig
        let success = MessageView.viewFromNib(layout: .messageView)
        success.configureTheme(.success)
        success.configureDropShadow()
        success.configureContent(title: title, body: body)
        success.button?.isHidden = true
        
        SwiftMessages.show(config: successConfig, view: success)
    }
}

