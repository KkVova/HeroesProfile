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
    var heroes: AnyPublisher<HeroModel, Never> { get }

    func loadHeroesList()
}

class HeroesManager: HeroesManagerProtocol {
    enum HeroesApiUrls: String {
        case heroesListUrl = "https://api.heroesprofile.com/openApi/Heroes"
        case heroIconUrl = "https://www.heroesprofile.com/includes/images/heroes/"
    }

    var heroes: AnyPublisher<HeroModel, Never> {
        self.heroPublisher.share().eraseToAnyPublisher()
    }

    private let heroPublisher = PassthroughSubject<HeroModel, Never>()
    private var cancellables = Set<AnyCancellable>()

    private let requestService: RequestServiceProtocol


    init(service: RequestServiceProtocol) {
        self.requestService = service
    }

    func loadHeroesList() {
        requestService.request(forUrl: HeroesApiUrls.heroesListUrl.rawValue) { [unowned self] result in
            switch result {
            case .success(let data):
                guard let list = try? JSONDecoder().decode([String: Hero].self, from: data) else {
                    print("Failed to decode some data.")
                    return
                }
                for hero in list.values {
                    DispatchQueue.global().async {
                        self.requestService.request(
                            forUrl:
                                "\(HeroesApiUrls.heroIconUrl.rawValue)\(hero.shortName).png") { [unowned self] result in
                                    switch result {
                                    case .success(let data):
                                        heroPublisher.send(HeroModel(name: hero.name, shortName: hero.shortName,
                                                                     iconData: data))
                                    case .failure(let error):
                                        print(error.localizedDescription)
                                    }
                                }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
