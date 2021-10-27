//
//  Item.swift
//  FreshBox
//
//  Created by Seydoux on 2021/10/12.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var id = 0
    @objc dynamic var name: String = ""
    @objc dynamic var memo: String = ""
    @objc dynamic var quantity: Int = 0
    @objc dynamic var favorite: Bool = false
    @objc dynamic var createdDate: Date = Date()
    @objc dynamic var expireDate: Date = Date()
    @objc dynamic var boughtDate: Date = Date()
    @objc dynamic var customExpireDate: Date = Date()
    @objc dynamic var itemImage: String = ""
    @objc dynamic var itemLocation: Int = 0 // 0: 냉장, 1: 냉동, 2: 기타
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
    let ofFridge = LinkingObjects(fromType: Fridge.self, property: "items")
}
