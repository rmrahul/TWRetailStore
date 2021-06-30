//
//  AppManager.swift
//  RetailStore
//
//  Created by Rahul Mane on 21/07/18.
//  Copyright © 2018 developer. All rights reserved.
//

import UIKit
import SwiftHEXColors

struct AppManager {
    enum TextStyle {
        case navigationBar
        case title
        case subtitle
        case body
        case button
        case tabbar
    }
    
    struct TextAttributes {
        let font: UIFont
        let color: UIColor
        let backgroundColor: UIColor?
        
        init(font: UIFont, color: UIColor, backgroundColor: UIColor? = nil) {
            self.font = font
            self.color = color
            self.backgroundColor = backgroundColor
        }
    }
    
    // MARK: - General Properties
    let backgroundColor: UIColor
    let preferredStatusBarStyle: UIStatusBarStyle
    
    let attributesForStyle: (_ style: TextStyle) -> TextAttributes

    init(backgroundColor: UIColor,
         preferredStatusBarStyle: UIStatusBarStyle = .default,
         attributesForStyle: @escaping (_ style: TextStyle) -> TextAttributes){
        self.backgroundColor = backgroundColor
        self.preferredStatusBarStyle = preferredStatusBarStyle
        self.attributesForStyle = attributesForStyle
    }
    
    // MARK: - Convenience Getters
    func font(for style: TextStyle) -> UIFont {
        return attributesForStyle(style).font
    }
    
    func color(for style: TextStyle) -> UIColor {
        return attributesForStyle(style).color
    }
    
    func backgroundColor(for style: TextStyle) -> UIColor? {
        return attributesForStyle(style).backgroundColor
    }
    
    func apply(textStyle: TextStyle, to label: UILabel) {
        let attributes = attributesForStyle(textStyle)
        label.font = attributes.font
        label.textColor = attributes.color
        label.backgroundColor = attributes.backgroundColor
    }
    
    func apply(textStyle: TextStyle = .button, to button: UIButton) {
        let attributes = attributesForStyle(textStyle)
        button.setTitleColor(attributes.color, for: .normal)
        button.titleLabel?.font = attributes.font
        button.backgroundColor = attributes.backgroundColor
    }
    
    func apply(textStyle: TextStyle = .navigationBar, to navigationBar: UINavigationBar) {
        let attributes = attributesForStyle(textStyle)
        navigationBar.titleTextAttributes = [
            NSAttributedStringKey.font: attributes.font,
            NSAttributedStringKey.foregroundColor: attributes.color
        ]
        
        if let color = attributes.backgroundColor {
            navigationBar.barTintColor = color
        }
        
        navigationBar.tintColor = attributes.color
        navigationBar.barStyle = preferredStatusBarStyle == .default ? .default : .black
    }

    func apply(textStyle: TextStyle = .tabbar, to tabBar: UITabBar) {
        let attributes = attributesForStyle(textStyle)
        tabBar.tintColor = attributes.backgroundColor
    }
}

extension AppManager{
    static var appStyle: AppManager {
        return AppManager(
            backgroundColor: .black,
            preferredStatusBarStyle: .lightContent,
            attributesForStyle: { $0.appAttributes }
        )
    }
}

private extension AppManager.TextStyle{
    var appAttributes : AppManager.TextAttributes{
        switch self {
        case .tabbar:fallthrough
        case .navigationBar:
            return AppManager.TextAttributes(font: UIFont(name: "AvenirNext-DemiBold", size: 16.0)!, color: UIColor(hexString:"#363636")!, backgroundColor: UIColor(hexString:"#F2A61C"))
        case .title:
            return AppManager.TextAttributes(font: UIFont(name: "AvenirNext-DemiBold", size: 15.0)!, color: UIColor(hexString:"#363636")!, backgroundColor: .white)
        case .subtitle:
            return AppManager.TextAttributes(font: UIFont(name: "AvenirNext-Regular", size: 15.0)!, color: UIColor(hexString:"#6f6f6f")!, backgroundColor: .white)
        case .body:
            return AppManager.TextAttributes(font: UIFont(name: "AvenirNext-Regular", size: 14.0)!, color: UIColor(hexString:"#363636")!, backgroundColor: .white)
        case .button:
            return AppManager.TextAttributes(font: UIFont(name: "AvenirNext-Regular", size: 14.0)!, color: UIColor(hexString:"#F2A61C")!, backgroundColor: .white)
        }
    }
}

