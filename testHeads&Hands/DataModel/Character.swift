//
//  Character.swift
//  testHeads&Hands
//
//  Created by Yegitov Aleksey on 30.09.2021.
//

import Foundation

struct CharacterLocation: Codable {
    public let name: String
    public let url: String
}

struct Character: Codable, Identifiable {
    public let id: Int
    public let name: String
    public let status: Status
    public let species: String
    public let type: String
    public let gender: Gender
    public let origin: CharacterLocation
    public let location: CharacterLocation
    public let image: String
    public let episode: [String]
    public let url: String
    public let created: String
}

public enum Status: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
    case none = ""
}

public enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"
    case none = ""
}
