//
//  Fridge.swift
//  FreshBox
//
//  Created by Seydoux on 2021/10/12.
//

import Foundation
import RealmSwift

class Fridge: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var fridgeImage: String = ""
    @objc dynamic var createdDate: Date = Date()
    
    let items = List<Item>()
}
