//
//  TalentModel.swift
//  HeroesProfile
//
//  Created by Vova Badyaev on 19.06.2022.
//

import Foundation


class TalentModel: Identifiable {
    let shortHeroName: String
    let title: String
    let description: String
    let sort: Int
    let level: Int
    let icon: Data

    init(name: String, title: String, description: String, sort: Int, level: Int, iconData: Data) {
        self.shortHeroName = name
        self.title = title
        self.description = description
        self.sort = sort
        self.level = level
        self.icon = iconData
    }
}
