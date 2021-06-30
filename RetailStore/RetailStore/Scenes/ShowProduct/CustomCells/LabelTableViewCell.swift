//
//  LabelTableViewCell.swift
//  RetailStore
//
//  Created by Rahul Mane on 21/07/18.
//  Copyright © 2018 developer. All rights reserved.
//

import UIKit

class LabelTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK: view lifecyle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //MARK: Configure
    func configureCell(attrText : NSAttributedString){
        self.lblTitle.attributedText = attrText
    }
}
