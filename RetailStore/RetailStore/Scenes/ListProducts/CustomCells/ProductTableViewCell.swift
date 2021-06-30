//
//  ProductTableViewCell.swift
//  RetailStore
//
//  Created by Rahul Mane on 21/07/18.
//  Copyright © 2018 developer. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblName: UILabel!

    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //MARK: Configurations
    func configureCell(viewModel : ListProducts.Fetch.ProductViewModel.DisplayedProduct){
        self.lblName.attributedText = viewModel.name
        self.lblPrice.attributedText = viewModel.price
    }
}
