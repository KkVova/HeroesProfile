//
//  HeroModel.swift
//  HOTSProfiles
//
//  Created by Vova Badyaev on 10.06.2022.
//

import Foundation
import UIKit


class HeroModel: Identifiable {
    let name: String
    let shortName: String
    var icon: Data

    init(name: String, shortName: String, iconData: Data) {
        self.name = name
        self.shortName = shortName
        self.icon = iconData
    }
}
