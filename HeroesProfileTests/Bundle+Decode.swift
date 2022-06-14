//
//  Bundle+Decode.swift
//  HeroesProfileTests
//
//  Created by Vova Badyaev on 14.06.2022.
//

import Foundation


extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T? {
        guard let url = self.url(forResource: file, withExtension: nil),
              let data = try? Data(contentsOf: url),
              let result = try? JSONDecoder().decode(T.self, from: data) else {
            return nil
        }

        return result
    }

    func data(from file: String) -> Data? {
        guard let url = self.url(forResource: file, withExtension: nil),
              let data = try? Data(contentsOf: url) else {
            return nil
        }

        return data
    }
}
