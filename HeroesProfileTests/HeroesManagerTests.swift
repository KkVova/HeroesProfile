//
//  HeroesManagerTests.swift
//  HeroesProfileTests
//
//  Created by Vova Badyaev on 14.06.2022.
//

import XCTest

@testable import HeroesProfile


class HeroesManagerTests: XCTestCase {
    var manager: HeroesManager!
    var service: RequestServiceMock!
    var jsonData: Data!
    var heroesList: [String: Hero]!

    override func setUp() {
        service = RequestServiceMock()
        manager = HeroesManager(service: service)
        jsonData = Bundle(for: type(of: self)).data(from: "testHeroesList.json")
        heroesList = Bundle(for: type(of: self)).decode([String: Hero].self, from: "testHeroesList.json")
    }

    func testHeroesManager_LoadHeroes() throws {
        let heroesPublisher = manager.heroes
            .collect(heroesList.count)
            .first()

        service.testCompletionHandler = { [unowned self] url, handler in
            switch url {
            case HeroesManager.HeroesApiUrls.heroesListUrl.rawValue:
                handler(.success(jsonData))
            default:
                handler(.success(UIImage(systemName: "person.fill")!.pngData()!))
            }
        }

        let result = try awaitPublisherUnwrapped(heroesPublisher) {
            manager.loadHeroesList()
        }

        for heroName in heroesList.keys {
            XCTAssert(result.contains(where: { $0.name == heroName }))
        }
    }

    func testHeroesManager_DataImage() throws {
        let heroesPublisher = manager.heroes
            .collect(heroesList.count)
            .first()

        guard let checkHero = heroesList.first else {
            XCTFail("Emptry test heroes list")
            return
        }

        guard let testIconData = UIImage(systemName: "person.fill")?.pngData() else {
            XCTFail("Can't extract test image data")
            return
        }

        service.testCompletionHandler = { [unowned self] url, handler in
            switch url {
            case HeroesManager.HeroesApiUrls.heroesListUrl.rawValue:
                handler(.success(jsonData))
            case "\(HeroesManager.HeroesApiUrls.heroIconUrl.rawValue)\(checkHero.value.shortName).png":
                handler(.success(testIconData))
            default:
                handler(.success(Data()))
            }
        }

        let result = try awaitPublisherUnwrapped(heroesPublisher) {
            manager.loadHeroesList()
        }

        guard let hero = result.filter({ $0.shortName == checkHero.value.shortName }).first else {
            XCTFail("Missing expected hero in result list")
            return
        }
        print("\(hero.shortName)")
        XCTAssert(hero.icon == testIconData)

        let anotherHeroes = result.filter({ $0.shortName != checkHero.value.shortName })
        XCTAssertEqual(anotherHeroes.count, 2)
        for heroName in anotherHeroes {
            XCTAssert(heroName.icon == Data())
        }
    }
}
