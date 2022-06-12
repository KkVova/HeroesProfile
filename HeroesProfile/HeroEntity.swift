//
//  HeroEntity.swift
//  HOTSProfiles
//
//  Created by Vova Badyaev on 11.06.2022.
//

import Foundation


class Hero: Decodable, Identifiable {
    enum RoleType: String {
        case Healer = "Healer"
        case Support = "Support"
        case MeleeAssassin = "Melee Assassin"
        case RangedAssassin = "Ranged Assassin"
        case Bruiser = "Bruiser"
        case Tank = "Tank"
    }

    let id: Int
    let name: String
    let shortName: String
    let role: RoleType
    let translations: [String]

    enum CodingKeys: String, CodingKey {
        case id, name, short_name, new_role, translations
    }

    init(name: String, role: RoleType) {
        self.id = Int.random(in: 1..<91)
        self.name = name
        self.shortName = name
        self.role = role
        self.translations = []
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        shortName = try container.decode(String.self, forKey: .short_name)
        guard let role = RoleType(rawValue: try container.decode(String.self, forKey: .new_role)) else {
            fatalError()
        }
        self.role = role
        translations = try container.decode([String].self, forKey: .translations)
    }
}

struct HeroesList: Decodable {
    var heroes: [Hero]

    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var tempArray = [Hero]()

        for key in container.allKeys {
            let decodedObject = try container.decode(Hero.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
            tempArray.append(decodedObject)
        }

        heroes = tempArray
    }
}
