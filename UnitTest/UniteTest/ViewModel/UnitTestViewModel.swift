//
//  UnitTestViewModel.swift
//  UnitTest
//
//  Created by Farido on 18/09/2024.
//

import Foundation
import Combine

class UnitTestViewModel: ObservableObject {
    enum DataError: LocalizedError {
        case noData
        case itemNotFound
    }

    @Published var isPremium: Bool
    @Published var dataArray: [String] = []
    @Published var selectedItem: String? = nil

    let dataService: NewDataServiceProtocol
    var cancellable = Set<AnyCancellable>()

    init(isPremium: Bool, dataService: NewDataServiceProtocol = NewMockDataService(items: nil)) {
        self.isPremium = isPremium
        self.dataService = dataService
    }

    func addItem(item: String) {
        guard !item.isEmpty else {return}
        self.dataArray.append(item)
    }

    func selectItem(item: String) {
        if let x = dataArray.first(where: {$0 == item}) {
            selectedItem = x
        } else {
            selectedItem = nil 
        }
    }

    func saveItem(item: String) throws {
        guard !item.isEmpty else {
            throw DataError.noData
        }

        if let x = dataArray.first(where: {$0 == item}) {
            print("Save Item Here!! \(x)")
        } else {
            throw DataError.itemNotFound
        }
    }

    func downloadWithEscaping() {
        dataService.downloadItemWithEscaping { [weak self] items in
            guard let self = self else {return}
            self.dataArray = items
        }
    }

    func downloadWithCombine() {
        dataService.downloadItemsWithCombine()
            .sink { _ in

            } receiveValue: { [weak self] items in
                guard let self = self else {return}
                self.dataArray = items
            }
            .store(in: &cancellable)

    }
}
