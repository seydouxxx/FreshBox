//
//  AddFridgeCollectionReusableView.swift
//  FreshBox
//
//  Created by Seydoux on 2021/10/15.
//

import UIKit

class AddFridgeCollectionReusableView: UICollectionReusableView {
    var AddFridgebutton: UIButton!
    
    private func setup() {
//        let lbl = UILabel(frame: bounds)
        let btn = UIButton(frame: bounds)
        btn.configuration = .filled()
        btn.configuration?.baseForegroundColor = .white
        btn.configuration?.baseBackgroundColor = .lightGray
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "plus"), for: .normal)
        
        addSubview(btn)
        
        btn.topAnchor.constraint(equalTo: topAnchor, constant: 10.0).isActive = true
        
        btn.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        btn.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        
        
        AddFridgebutton = btn
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}
