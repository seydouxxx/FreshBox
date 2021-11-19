//
//  AddFridgeCollectionReusableView.swift
//  FreshBox
//
//  Created by Seydoux on 2021/10/15.
//

import UIKit

class AddFridgeCollectionReusableView: UICollectionReusableView {
    var AddFridgebutton: UIButton!
//    TODO: IOS VERSION SUPPORT
    private func setup() {
        let btn = UIButton(frame: bounds)
//        if #available(iOS 15.0, *) {
//            btn.configuration = .filled()
//            btn.configuration?.baseForegroundColor = .white
//            btn.configuration?.baseBackgroundColor = .lightGray
//        } else {
//
//        }
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "plus"), for: .normal)
        btn.tintColor = Constants.themeColor
        
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
