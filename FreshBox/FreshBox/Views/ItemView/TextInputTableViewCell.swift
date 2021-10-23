//
//  TextInputTableViewCell.swift
//  FreshBox
//
//  Created by Seydoux on 2021/10/21.
//

import UIKit

class TextInputTableViewCell: UITableViewCell {
    var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tf = UITextField()
        
        textField = tf
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
