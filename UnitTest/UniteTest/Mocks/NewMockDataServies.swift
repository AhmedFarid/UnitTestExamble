//
//  NewMockDataServies.swift
//  UnitTest
//
//  Created by Farido on 18/09/2024.
//

import Foundation
import Combine

protocol NewDataServiceProtocol {
    func downloadItemWithEscaping(completion: @escaping (_ items: [String]) -> ())
    func downloadItemsWithCombine() -> AnyPublisher<[String], Error>
}

class NewMockDataService: NewDataServiceProtocol {

    let items: [String]

    init(items: [String]?) {
        self.items = items ?? [
            "1", "2", "3"
        ]
    }

    func downloadItemWithEscaping(completion: @escaping (_ items: [String]) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completion(self.items)
        }
    }

    func downloadItemsWithCombine() -> AnyPublisher<[String], Error> {
        Just(items)
            .tryMap({ publishedItems in
                guard !publishedItems.isEmpty else {
                    throw URLError(.badServerResponse)
                }
                return publishedItems
            })
            .eraseToAnyPublisher()
    }
}
