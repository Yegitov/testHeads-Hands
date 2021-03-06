//
//  Planet.swift
//  testHeads&Hands
//
//  Created by Yegitov Aleksey on 30.09.2021.
//

import Foundation

class Location: Codable, Identifiable, Comparable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }

    static func < (lhs: Location, rhs: Location) -> Bool {
        return lhs.id < rhs.id
    }

    public let id: Int
    public let name: String
    public let type: String
    public let dimension: String
    public let residents: [String]
    public let url: String
    public let created: String
}
