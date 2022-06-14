//
//  HeroesManagerMock.swift
//  HeroesProfileTests
//
//  Created by Vova Badyaev on 18.06.2022.
//

import Combine
import Foundation

@testable import HeroesProfile
import UIKit


class HeroesManagerMock: HeroesManagerProtocol {
    var heroes: AnyPublisher<HeroModel, Never> { heroesPublisher.share().eraseToAnyPublisher() }

    let heroesPublisher = PassthroughSubject<HeroModel, Never>()
    func loadHeroesList() {}
}

