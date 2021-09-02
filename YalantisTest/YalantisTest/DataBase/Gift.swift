//
//  Gift.swift
//  YalantisTest
//
//  Created by Danil Tymofeev on 01.09.2021.
//

import Foundation
import RealmSwift

class Gift: Object{
    @objc dynamic var item = String()
    @objc dynamic var price = Int()
    @objc dynamic var check = Bool()
}

class Stack: Object{
    @objc dynamic var stack = Int()
}
