//
//  User.swift
//  Friendface
//
//  Created by Bruce Gilmour on 2021-07-25.
//

import Foundation

class FriendfaceData: ObservableObject {
    var users: [User] = Bundle.main.decode("friendface.json")
}

struct User: Identifiable, Codable {
    let id: UUID
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let email: String
    let address: String
    let about: String
    let registered: Date
    let tags: [String]
    let friends: [Friend]
}

struct Friend: Identifiable, Codable {
    let id: UUID
    let name: String
}
