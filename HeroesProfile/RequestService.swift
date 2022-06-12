//
//  RequestService.swift
//  HOTSProfiles
//
//  Created by Vova Badyaev on 11.06.2022.
//

import Alamofire
import Combine
import Foundation


struct NetworkError: Error {
    let initialError: AFError
    let backendError: BackendError?
}

struct BackendError: Codable, Error {
    var status: String
    var message: String
}

protocol RequestServiceProtocol {
    func request(forUrl url: String) -> AnyPublisher<Data, Error>
}

class RequestService: RequestServiceProtocol {
    private var cancellables = Set<AnyCancellable>()

    func request(forUrl url: String) -> AnyPublisher<Data, Error> {
        return Future<Data, Error> { promise in
            AF.request(url, method: .get).response { response in
                switch response.result {
                case .success(let responseData):
                    return promise(.success(responseData!))
                case .failure(let error):
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return promise(.failure(NetworkError(initialError: error, backendError: backendError)))
                }
            }
        }.eraseToAnyPublisher()
    }
}
