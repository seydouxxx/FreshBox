//
//  ItemTableViewCell.swift
//  FreshBox
//
//  Created by Seydoux on 2021/10/28.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    var titleLabel: UILabel!
    var detailLabel: UILabel!
//    var imageView: UIImageView
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel = UILabel()
        detailLabel = UILabel()
        
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = 5
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        detailLabel.textColor = .darkGray
        detailLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize * 0.9)
        
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(detailLabel)
        contentView.addSubview(verticalStackView)
        
        verticalStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0).isActive = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
