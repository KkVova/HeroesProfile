//
//  HeroManager.swift
//  HeroesProfile
//
//  Created by Vova Badyaev on 13.06.2022.
//

import Combine
import Foundation
import UIKit


protocol HeroesManagerProtocol {
    var heroesList: [HeroModel] { get }

    func loadHeroesList(_ completionHandler: @escaping (Error?) -> Void)
}

class HeroesManager: HeroesManagerProtocol {
    enum HeroesApiUrls: String {
        case heroesListUrl = "https://api.heroesprofile.com/openApi/Heroes"
        case heroIconUrl = "https://www.heroesprofile.com/includes/images/heroes/"
    }

    var heroesList: [HeroModel] {
        let heroes = Array(heroToTalents.keys)
        return heroes.sorted {$0.shortName < $1.shortName}
    }

    private let requestService: RequestServiceProtocol

    private var heroToTalents: [HeroModel: [Talent]?] = [:]

    init(service: RequestServiceProtocol) {
        self.requestService = service
    }

    func loadHeroesList(_ completionHandler: @escaping (Error?) -> Void) {
        requestService.request(forUrl: HeroesApiUrls.heroesListUrl.rawValue) { [unowned self] result in
            switch result {
            case .success(let data):
                guard let list = try? JSONDecoder().decode([String: Hero].self, from: data) else {
                    print("Failed to decode some data.")
                    return
                }
                heroToTalents.reserveCapacity(list.count)
                for hero in list.values {
                    self.requestService.request(
                        forUrl:
                            "\(HeroesApiUrls.heroIconUrl.rawValue)\(hero.shortName).png") { [unowned self] result in
                                switch result {
                                case .success(let data):
                                    let hero = HeroModel(name: hero.name, shortName: hero.shortName,
                                                         iconData: data)
                                    heroToTalents.updateValue(nil, forKey: hero)
                                    completionHandler(nil)
                                case .failure(let error):
                                    completionHandler(error)
                                }
                            }
                }
            case .failure(let error):
                completionHandler(error)
            }
        }
    }
}
