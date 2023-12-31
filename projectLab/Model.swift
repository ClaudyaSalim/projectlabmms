//
//  Model.swift
//  projectLab
//
//  Created by prk on 04/12/23.
//s

import Foundation

struct Person {
    var name: String?
    var email: String?
    var pass: String?
}

struct Item {
    var name: String?
    var category: String?
    var price: Int?
    var desc:String?
    var img:String?
}

struct CartItem {
    var userEmail: String?
    var productName: String?
    var qty: Int?
    var price: Int?
}
