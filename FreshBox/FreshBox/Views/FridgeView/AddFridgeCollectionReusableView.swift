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
        
        //  코드를 통한 오토레이아웃으로 뷰의 크기를 조정하고 싶으면 이 프로퍼티 값을 false로 주어야 함
//        lbl.translatesAutoresizingMaskIntoConstraints = false
//        lbl.font = UIFont.boldSystemFont(ofSize: 30)
//        addSubview(lbl)
//
//        lbl.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1.0).isActive = true
//        lbl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        lbl.textAlignment = .center
//        testFooterLabel = lbl
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
