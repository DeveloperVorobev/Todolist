//
//  CategoryModel.swift
//  Todoey
//
//  Created by Владислав Воробьев on 18.07.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryRealmModel: Object {
    @Persisted var name: String = ""

    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
