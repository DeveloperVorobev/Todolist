//
//  Item.swift
//  Todoey
//
//  Created by Владислав Воробьев on 12.07.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct Item: Codable {
    var title: String = ""
    var done: Bool = false
}
