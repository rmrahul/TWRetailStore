//
//  ShowProductViewController.swift
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

protocol ShowProductDisplayLogic: class{
    func displayProduct(viewModel: ShowProduct.Fetch.DisplayedProductViewModel)
    func displaySuccessOfAddCart(viewModel: ShowProduct.AddToCart.DisplayedProductViewModel)
    func displayError(viewModel: ShowProduct.Fetch.ErrorViewModel)
    func displayError(viewModel: ShowProduct.AddToCart.ErrorViewModel)
}

class ShowProductViewController: UIViewController, ShowProductDisplayLogic,UITableViewDataSource,UITableViewDelegate,ButtonTableViewCellDelegate{
    private var interactor: ShowProductBusinessLogic?
    var router: (NSObjectProtocol & ShowProductRoutingLogic & ShowProductDataPassing)?
    var displayedProduct : ShowProduct.Fetch.DisplayedProductViewModel?
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    private func setup(){
        let viewController = self
        let interactor = ShowProductInteractor()
        let presenter = ShowProductPresenter()
        let router = ShowProductRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    override func viewDidLoad(){
        super.viewDidLoad()
        applyUI()
        fetchProduct()
    }
    
    //MARK: Apply UI
    private func applyUI(){
        AppManager.appStyle.apply(textStyle: AppManager.TextStyle.navigationBar, to: (self.navigationController?.navigationBar)!)
    }
    
    // MARK: Interactor communication
    private func fetchProduct(){
        let request = ShowProduct.Fetch.Request()
        interactor?.fetchProduct(request: request)
    }
    
    // MARK: Presentor commands
    func displayProduct(viewModel: ShowProduct.Fetch.DisplayedProductViewModel){
        displayedProduct = viewModel
        tableView.reloadData()
    }
    func displaySuccessOfAddCart(viewModel: ShowProduct.AddToCart.DisplayedProductViewModel){
        AppUtil.showSuccess(title: viewModel.title, body: viewModel.message)
    }
    
    func displayError(viewModel: ShowProduct.Fetch.ErrorViewModel){
        AppUtil.showError(title: viewModel.title, body: viewModel.message)
    }
    
    func displayError(viewModel: ShowProduct.AddToCart.ErrorViewModel){
        AppUtil.showError(title: viewModel.title, body: viewModel.message)
    }
    
    // MARK: UI - tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return displayedProduct?.tableRepresentation.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        guard let rowType = displayedProduct?.tableRepresentation[indexPath.row] else{
            //log error..
            return UITableViewCell()
        }
        switch rowType {
        case .icon(let url):
            let imageCell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! ImageTableViewCell
            imageCell.configure(imageURL: url)
            return imageCell
        case .name(let value), .price(let value):
            let labelCell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelTableViewCell
            labelCell.configureCell(attrText: value)
            return labelCell
        case .addToCart:
            let buttonCell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as! ButtonTableViewCell
            buttonCell.delegate = self
            return buttonCell
        }
    }
    
    //MARK: Actions
    func btnClicked(sender : ButtonTableViewCell){
        let request = ShowProduct.AddToCart.Request()
        interactor?.addToCart(request: request)
    }
}
