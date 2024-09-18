//
//  NewMockDataServies_Test.swift
//  UnitTest_Tests
//
//  Created by Farido on 18/09/2024.
//

import XCTest
@testable import UnitTest
import Combine

final class NewMockDataServies_Test: XCTestCase {

    var cancellable = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cancellable.removeAll()
    }

    func test_NewMockDataService_init_setValuesCorrectly() {
        // Given
        let item: [String]? = nil
        let item2: [String]? = []
        let item3: [String]? = [UUID().uuidString, UUID().uuidString]

        // When
        let dataService = NewMockDataService(items: item)
        let dataService2 = NewMockDataService(items: item2)
        let dataService3 = NewMockDataService(items: item3)

        // Then
        XCTAssertFalse(dataService.items.isEmpty)
        XCTAssertTrue(dataService2.items.isEmpty)
        XCTAssertEqual(dataService3.items.count, 2)
    }

    func test_NewMockDataService_downloadItemsWithEscaping_doseReturnValues() {
        // Given
        let dataService = NewMockDataService(items: nil)

        // When
        var items: [String] = []
        let expectation = XCTestExpectation()
        dataService.downloadItemWithEscaping { returnedItem in
            items = returnedItem
            expectation.fulfill()
        }

        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(items.count, dataService.items.count)

    }

    func test_NewMockDataService_downloadItemsCompine_doseReturnValues() {
        // Given
        let dataService = NewMockDataService(items: nil)

        // When
        var items: [String] = []
        let expectation = XCTestExpectation()
        dataService.downloadItemsWithCombine()
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case.failure:
                    XCTFail()
                }
            } receiveValue: { returnedItem in
                items = returnedItem
            }
            .store(in: &cancellable)

        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(items.count, dataService.items.count)
    }

    func test_NewMockDataService_downloadItemsCompine_doseFail() {
        // Given
        let dataService = NewMockDataService(items: [])

        // When
        var items: [String] = []
        let expectation = XCTestExpectation(description: "Dose throw an error")
        let expectation2 = XCTestExpectation(description: "Dose throw URLError badServerResponse")
        dataService.downloadItemsWithCombine()
            .sink { completion in
                switch completion {
                case .finished:
                    XCTFail()
                case.failure(let error):
                    expectation.fulfill()
                    let urlError = error as? URLError
                    XCTAssertEqual(urlError, URLError(.badServerResponse))

                    if urlError == URLError(.badServerResponse) {
                        expectation2.fulfill()
                    }
                }
            } receiveValue: { returnedItem in
                items = returnedItem
            }
            .store(in: &cancellable)

        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(items.count, dataService.items.count)

    }
}
