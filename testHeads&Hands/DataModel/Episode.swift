//
//  Episode.swift
//  testHeads&Hands
//
//  Created by Yegitov Aleksey on 30.09.2021.
//

import Foundation

struct Episode: Codable, Identifiable, Comparable {
    static func < (lhs: Episode, rhs: Episode) -> Bool {
        return lhs.id < rhs.id
    }

    public let id: Int
    public let name: String
    public let airDate: String
    public let episode: String
    public let characters: [String]
    public let url: String
    public let created: String

    enum CodingKeys: String, CodingKey {
        case id, name, episode, characters, url, created
        case airDate = "air_date"
    }
}
