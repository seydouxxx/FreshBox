//
//  FridgeCollectionViewCell.swift
//  FreshBox
//
//  Created by Seydoux on 2021/10/10.
//

import UIKit

class FridgeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var fridgeImage: UIImageView!
    @IBOutlet weak var fridgeNameLabel: UILabel!
    @IBOutlet weak var fridgeDetailLabel: UILabel!
    let cornerRadius = 20.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.layer.borderWidth = 1.0
        contentView.layer.cornerRadius = self.cornerRadius
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
//        layer.shadowColor = UIColor.lightGray.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        layer.shadowRadius = 6.0
//        layer.shadowOpacity = 1.0
//        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        layer.backgroundColor = UIColor.clear.cgColor
        layer.masksToBounds = false
    }
    
}
