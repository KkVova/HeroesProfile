//
//  XCTestCase+ExpectationWaiter.swift
//  HeroesProfileTests
//
//  Created by Vova Badyaev on 14.06.2022.
//

import Combine
import XCTest


extension XCTestCase {
    @discardableResult
    func awaitPublisher<T: Publisher>(
        _ publisher: T,
        isInverted: Bool = false,
        timeout: TimeInterval = 3,
        doBefore: () -> Void = {},
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> Result<T.Output, Error>? {
        var result: Result<T.Output, Error>?

        let expectation = self.expectation(description: "Awaiting publisher")
        expectation.isInverted = isInverted

        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    result = .failure(error)
                    expectation.fulfill()
                case .finished:
                    break
                }
            },
            receiveValue: { value in
                result = .success(value)
                expectation.fulfill()
            }
        )
        defer {
            cancellable.cancel()
        }

        doBefore()
        waitForExpectations(timeout: timeout)

        return result
    }

    @discardableResult
    func awaitPublisherUnwrapped<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 3,
        doBefore: () -> Void = {},
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> T.Output {
        let result = try awaitPublisher(
            publisher,
            isInverted: false,
            timeout: timeout,
            doBefore: doBefore,
            file: file,
            line: line)

        let unwrappedResult = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        )

        return try unwrappedResult.get()
    }
}
