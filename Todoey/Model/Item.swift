//
//  ItemRealmModel.swift
//  Todoey
//
//  Created by Владислав Воробьев on 18.07.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @Persisted var title: String = ""
    @Persisted var done: Bool = false
    @Persisted var createdDate: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
