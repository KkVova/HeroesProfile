//
//  RequestService.swift
//  HOTSProfiles
//
//  Created by Vova Badyaev on 11.06.2022.
//

import Alamofire
import Combine
import Foundation


enum ResponseError: Error {
    case emptyResponse
    case unknownError
}

struct NetworkError: Error {
    let initialError: AFError
    let backendError: BackendError?
}

struct BackendError: Codable, Error {
    var status: String
    var message: String
}

protocol RequestServiceProtocol {
    func request(forUrl url: String, completionHandler: @escaping (Result<Data, Error>) -> Void)
}

class RequestService: RequestServiceProtocol {
    func request(forUrl url: String, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        AF.request(url, method: .get).response { response in
            switch response.result {
            case .success(let responseData):
                guard let data = responseData else {
                    completionHandler(.failure(ResponseError.emptyResponse))
                    return
                }
                completionHandler(.success(data))
            case .failure(let error):
                let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                completionHandler(.failure(NetworkError(initialError: error, backendError: backendError)))
            }
        }
    }
}

