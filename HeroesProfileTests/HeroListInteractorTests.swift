//
//  HeroListInteractorTests.swift
//  HeroesProfileTests
//
//  Created by Vova Badyaev on 18.06.2022.
//

import XCTest

@testable import HeroesProfile


class HeroListInteractorTests: XCTestCase {
    var interactor: HeroListInteractor!
    var manager: HeroesManagerMock!

    override func setUp() {
        manager = HeroesManagerMock()
        interactor = HeroListInteractor(heroManager: manager)
    }

    func testHeroListInteractor_ReceiveHeroModel() throws {
        let heroesPublisher = interactor.heroes
            .first()

        let name = "test name"
        let shortName = "short name"
        let testData = Data(repeating: 0x01, count: 10)

        let result = try awaitPublisherUnwrapped(heroesPublisher) {
            manager.heroesPublisher.send(HeroModel(name: name, shortName: shortName, iconData: testData))
        }
        XCTAssertEqual(result.name, name)
        XCTAssertEqual(result.shortName, shortName)
        XCTAssertEqual(result.icon, testData)
    }
}
