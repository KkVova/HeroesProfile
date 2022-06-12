//
//  HeroListInteractor.swift
//  HOTSProfiles
//
//  Created by Vova Badyaev on 10.06.2022.
//

import Combine
import Foundation
import UIKit


protocol HeroListInteractorProtocol {
    var heroes: AnyPublisher<HeroModel, Never> { get }

    func loadList()
}

class HeroListInteractor: HeroListInteractorProtocol {
    var heroes: AnyPublisher<HeroModel, Never> { heroesPublisher.share().eraseToAnyPublisher() }

    private let heroesPublisher = PassthroughSubject<HeroModel, Never>()
    private var cancellables = Set<AnyCancellable>()

    private var heroManager: HeroManagerProtocol

    init(heroManager: HeroManagerProtocol) {
        self.heroManager = heroManager

        heroManager.heroes
            .receive(on: DispatchQueue.global())
            .sink { [unowned self] hero in
                self.heroesPublisher.send(hero)
            }
            .store(in: &cancellables)
    }

    func loadList() {
        heroManager.loadHeroesList()
    }
}
