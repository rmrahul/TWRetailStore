//
//  CartProductTableViewCell.swift
//  RetailStore
//
//  Created by Rahul Mane on 21/07/18.
//  Copyright © 2018 developer. All rights reserved.
//

import UIKit
protocol CartProductTableViewCellDelegate : class {
    func didSelectRemoveFromCart(viewModel : Cart.ViewModel.DisplayedProduct?)
}

class CartProductTableViewCell: UITableViewCell {
    var displayedProduct : Cart.ViewModel.DisplayedProduct?
    weak var delegate : CartProductTableViewCellDelegate?
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var btnRemoveFromCart: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //MARK : Config
    func configureCell(viewModel :Cart.ViewModel.DisplayedProduct?){
        displayedProduct = viewModel
        lblName.attributedText = viewModel?.name
        lblCategory.attributedText = viewModel?.category
        lblPrice.attributedText = viewModel?.price
        lblCount.attributedText = viewModel?.count
        lblSubTotal.attributedText = viewModel?.subtotal
        icon.setURL(viewModel?.image)
    }
    
    //MARK : Actions
    @IBAction func btnRemoveFromCartClicked(_ sender: Any) {
        self.delegate?.didSelectRemoveFromCart(viewModel: displayedProduct)
    }
}
