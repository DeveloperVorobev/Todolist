//
//  CategoryModel.swift
//  Todoey
//
//  Created by Владислав Воробьев on 18.07.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @Persisted var name: String = ""
    @Persisted var items = List<Item>()
    @Persisted var colorForCategory: String = ""
}
