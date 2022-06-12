//
//  HeroManager.swift
//  HeroesProfile
//
//  Created by Vova Badyaev on 13.06.2022.
//

import Combine
import Foundation
import UIKit


protocol HeroManagerProtocol {
    var heroes: AnyPublisher<HeroModel, Never> { get }

    func loadHeroesList()
}

class HeroesManager: HeroManagerProtocol {
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
        requestService.request(forUrl: "https://api.heroesprofile.com/openApi/Heroes")
            .receive(on: DispatchQueue.global())
            .sink(receiveCompletion: { comp in
                if case .failure(let error) = comp {
                    print("ERROR!!!!! \(error.localizedDescription)")
                }
            }, receiveValue: { [unowned self] data in
                guard let list = try? JSONDecoder().decode(HeroesList.self, from: data) else {
                    print("ERROR!!!!! Cant convert image")
                    return
                }
                for hero in list.heroes {
                    requestService.request(forUrl: "https://www.heroesprofile.com/includes/images/heroes/\(hero.shortName).png")
                        .receive(on: DispatchQueue.global())
                        .sink(receiveCompletion: { comp in
                            if case .failure(let error) = comp {
                                print("ERROR!!!!! \(error.localizedDescription)")
                            }
                        }, receiveValue: { [unowned self] data in
                            guard let image = UIImage(data: data) else {
                                print("ERROR!!!!! Cant convert image")
                                return
                            }
                            heroPublisher.send(HeroModel(name: hero.name, shortName: hero.shortName, icon: image))
                        })
                        .store(in: &cancellables)
                }
            })
            .store(in: &cancellables)
    }
}
