//
//  HeroModel.swift
//  HeroesProfile
//
//  Created by Vova Badyaev on 10.06.2022.
//

import Foundation


class HeroModel: Identifiable, Hashable {
    let name: String
    let shortName: String
    var icon: Data

    init(name: String, shortName: String, iconData: Data) {
        self.name = name
        self.shortName = shortName
        self.icon = iconData
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }

    static func == (lhs: HeroModel, rhs: HeroModel) -> Bool {
        return lhs.name == rhs.name
    }
}
