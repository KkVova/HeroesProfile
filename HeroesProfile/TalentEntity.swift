//
//  TalentEntity.swift
//  HeroesProfile
//
//  Created by Vova Badyaev on 18.06.2022.
//

import Foundation


class Talent: Decodable, Identifiable {
    let heroId: Int
    let shortHeroName: String
    let talentId: Int
    let title: String
    let description: String
    let sort: Int
    let level: Int
    let iconName: String

    enum CodingKeys: String, CodingKey {
        case id, short_name, talent_id, title, description, sort, level, icon
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        heroId = try container.decode(Int.self, forKey: .id)
        shortHeroName = try container.decode(String.self, forKey: .short_name)
        talentId = try container.decode(Int.self, forKey: .talent_id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        guard let value = Int(try container.decode(String.self, forKey: .sort)) else {
            fatalError()
        }
        sort = value
        level = try container.decode(Int.self, forKey: .level)
        iconName = try container.decode(String.self, forKey: .icon)
    }
}
