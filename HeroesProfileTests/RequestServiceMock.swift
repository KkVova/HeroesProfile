//
//  RequestServiceMock.swift
//  HeroesProfileTests
//
//  Created by Vova Badyaev on 14.06.2022.
//

import Combine
import Foundation

@testable import HeroesProfile
import UIKit


class RequestServiceMock: RequestServiceProtocol {
    func request(forUrl url: String, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        testCompletionHandler(url, completionHandler)
    }

    var testCompletionHandler: (String, @escaping (Result<Data, Error>) -> Void) -> Void = { _, _ in }
}
