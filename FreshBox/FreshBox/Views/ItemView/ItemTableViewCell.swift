//
//  ItemTableViewCell.swift
//  FreshBox
//
//  Created by Seydoux on 2021/11/01.
//

import UIKit
import SwipeCellKit

class ItemTableViewCell: SwipeTableViewCell {

    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var expireDateLabel: UILabel!
    @IBOutlet weak var titleStackView: UIStackView!
    @IBOutlet weak var quantityStackView: UIStackView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    
    var increaseQuantity: (() -> ())?
    var decreaseQuantity: (() -> ())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        memoLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize*0.9)
        memoLabel.textColor = .darkGray
        
        foodImageView.layer.cornerRadius = 10
        foodImageView.layer.borderWidth = 1
        foodImageView.layer.borderColor = UIColor.clear.cgColor
        foodImageView.layer.masksToBounds = true
        
        expireDateLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize*0.8)
        
        expireDateLabel.textColor = .white
        expireDateLabel.textAlignment = .center
        expireDateLabel.backgroundColor = UIColor.init(red: 236/255.0, green: 103/255.0, blue: 82/255.0, alpha: 1)
        expireDateLabel.layer.cornerRadius = expireDateLabel.frame.width/4.5
        expireDateLabel.layer.masksToBounds = true
        
        quantityLabel.textAlignment = .center
        
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.clear.cgColor
        containerView.layer.cornerRadius = 5
        containerView.layer.masksToBounds = true
        
        contentView.layer.shadowColor = UIColor.darkGray.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentView.layer.shadowRadius = 2
        
        plusBtn.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        plusBtn.tintColor = Constants.themeColor
        plusBtn.tag = 0
        minusBtn.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        minusBtn.tintColor = Constants.themeColor
        minusBtn.tag = 1
        
        plusBtn.setTitle("", for: .normal)
        minusBtn.setTitle("", for: .normal)
        
        plusBtn.addTarget(self, action: #selector(plusBtnPressed(_:)), for: .touchUpInside)
        minusBtn.addTarget(self, action: #selector(minusBtnPressed(_:)), for: .touchUpInside)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    @IBAction func minusBtnPressed(_ sender: UIButton) {
        decreaseQuantity?()
    }
    @IBAction func plusBtnPressed(_ sender: UIButton) {
        increaseQuantity?()
    }
}
