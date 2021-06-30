//
//  ButtonTableViewCell.swift
//  RetailStore
//
//  Created by Rahul Mane on 22/07/18.
//  Copyright © 2018 developer. All rights reserved.
//

import UIKit

protocol ButtonTableViewCellDelegate : class{
    func btnClicked(sender : ButtonTableViewCell)
}

class ButtonTableViewCell: UITableViewCell {
    weak var delegate : ButtonTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //MARK: Actions
    @IBAction func btnAddToCartClicked(_ sender: Any) {
        delegate?.btnClicked(sender: self)
    }
}
