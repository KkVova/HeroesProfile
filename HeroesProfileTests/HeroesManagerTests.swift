//
//  HeroesManagerTests.swift
//  HeroesProfileTests
//
//  Created by Vova Badyaev on 14.06.2022.
//

import XCTest

@testable import HeroesProfile


class HeroesManagerTests: XCTestCase {
    enum HeroesManagerError: Error {
        case listLoading
        case imageLoading
    }

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

    func testHeroesManager_LoadHeroes() {
        let expectation = XCTestExpectation(description: "Waiting for HeroModels receiving.")

        service.testCompletionHandler = { [unowned self] url, handler in
            switch url {
            case HeroesManager.HeroesApiUrls.heroesListUrl.rawValue:
                handler(.success(jsonData))
            default:
                handler(.success(UIImage(systemName: "person.fill")!.pngData()!))
            }
        }

        manager.loadHeroesList { error in
            if error != nil {
                return
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
        for heroName in manager.heroesList {
            XCTAssert(heroesList.contains(where: { $0.value.shortName == heroName.shortName }))
        }
        XCTAssertEqual(heroesList.count, manager.heroesList.count)
    }

    func testHeroesManager_ErrorOnListLoading() {
        let expectation = XCTestExpectation(description: "Waiting for error receiving.")

        service.testCompletionHandler = { url, handler in
            switch url {
            case HeroesManager.HeroesApiUrls.heroesListUrl.rawValue:
                handler(.failure(HeroesManagerError.listLoading))
            default:
                handler(.failure(HeroesManagerError.imageLoading))
            }
        }

        manager.loadHeroesList { error in
            if let err = error {
                switch err {
                case HeroesManagerError.listLoading:
                    expectation.fulfill()
                default:
                    break
                }
            }
        }

        wait(for: [expectation], timeout: 1)
    }

    func testHeroesManager_ErrorOnImageLoading() {
        var expectations: [XCTestExpectation] = []

        for i in 0..<heroesList.count {
            expectations.append(XCTestExpectation(description: "Waiting for HeroModel №\(i) receiving."))
        }
        service.testCompletionHandler = { [unowned self] url, handler in
            switch url {
            case HeroesManager.HeroesApiUrls.heroesListUrl.rawValue:
                handler(.success(jsonData))
            default:
                handler(.failure(HeroesManagerError.imageLoading))
            }
        }

        manager.loadHeroesList { error in
            if let err = error {
                switch err {
                case HeroesManagerError.imageLoading:
                    expectations.popLast()?.fulfill()
                case HeroesManagerError.listLoading:
                    return
                default:
                    break
                }
            }
        }

        wait(for: expectations, timeout: 1)
    }
}
