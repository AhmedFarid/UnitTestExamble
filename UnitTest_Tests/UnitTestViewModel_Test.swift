//
//  UnitTestViewModel_Test.swift
//  UnitTest_Tests
//
//  Created by Farido on 18/09/2024.
//

import XCTest
@testable import UnitTest
import Combine

final class UnitTestViewModel_Test: XCTestCase {
    var viewModel: UnitTestViewModel?
    var cancellable = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = UnitTestViewModel(isPremium: Bool.random())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        cancellable.removeAll()
    }

    func testـUnitTestViewModelـisPremium_shouldBeTrue() {
        // Given
        let userIsPremium: Bool = true

        // When
        let vm = UnitTestViewModel(isPremium: userIsPremium)

        // Then
        XCTAssertTrue(vm.isPremium)
    }

    func testـUnitTestViewModelـisPremium_shouldBeFalse() {
        // Given
        let userIsPremium: Bool = false

        // When
        let vm = UnitTestViewModel(isPremium: userIsPremium)

        // Then
        XCTAssertFalse(vm.isPremium)
    }

    func testـUnitTestViewModelـisPremium_shouldBeInjectedValue() {
        // Given
        let userIsPremium: Bool = Bool.random()

        // When
        let vm = UnitTestViewModel(isPremium: userIsPremium)

        // Then
        XCTAssertEqual(vm.isPremium, userIsPremium)
    }

    func testـUnitTestViewModelـisPremium_shouldBeInjectedValue_stress() {
        for _ in 0..<10 {
            // Given
            let userIsPremium: Bool = Bool.random()

            // When
            let vm = UnitTestViewModel(isPremium: userIsPremium)

            // Then
            XCTAssertEqual(vm.isPremium, userIsPremium)
        }
    }

    func test_UnitTestViewModel_dataArray_shouldBeEmpty() {
        // Given

        // When init viewModel
        let vm = UnitTestViewModel(isPremium: Bool.random())

        // Then
        XCTAssertTrue(vm.dataArray.isEmpty)
        XCTAssertEqual(vm.dataArray.count, 0)
    }

    func test_UnitTestViewModel_dataArray_shouldAddItems() {
        // Given
        let vm = UnitTestViewModel(isPremium: Bool.random())

        // When When we call addItem
        let loopCount: Int = Int.random(in: 1..<100)
        for _ in 0..<loopCount {
            vm.addItem(item: UUID().uuidString)
        }
        // Then
        XCTAssertFalse(vm.dataArray.isEmpty)
        XCTAssertEqual(vm.dataArray.count, loopCount)
        XCTAssertNotEqual(vm.dataArray.count, 0)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
        XCTAssertGreaterThanOrEqual(vm.dataArray.count, 0)
    }

    func test_UnitTestViewModel_dataArray_shouldNotAddBlankString() {
        // Given
        let vm = UnitTestViewModel(isPremium: Bool.random())

        // When we call addItem
        vm.addItem(item: "")

        // Then
        XCTAssertTrue(vm.dataArray.isEmpty)
        XCTAssertEqual(vm.dataArray.count, 0)
        XCTAssertLessThanOrEqual(vm.dataArray.count, 0)
    }

    func test_UnitTestViewModel_dataArray_shouldNotAddBlankString2() {
        // Given
        guard let vm = viewModel else {return}

        // When we call addItem
        vm.addItem(item: "")

        // Then
        XCTAssertTrue(vm.dataArray.isEmpty)
        XCTAssertEqual(vm.dataArray.count, 0)
        XCTAssertLessThanOrEqual(vm.dataArray.count, 0)
    }

    func test_UnitTestViewModel_selectedItem_shouldStartAsNil() {
        // Given

        // When init viewModel
        let vm = UnitTestViewModel(isPremium: Bool.random())

        // Then
        XCTAssertTrue(vm.selectedItem == nil)
        XCTAssertNil(vm.selectedItem)
    }

    func test_UnitTestViewModel_selectedItem_shouldBeNilWhenSelectingInvalidItem() {
        // Given
        let vm = UnitTestViewModel(isPremium: Bool.random())

        // When call selectItem
        // select valid item
        let newItem = UUID().uuidString
        vm.addItem(item: newItem)
        vm.selectItem(item: newItem)

        // select inValid item
        vm.selectItem(item: UUID().uuidString)

        // Then
        XCTAssertNil(vm.selectedItem)
    }

    func test_UnitTestViewModel_selectedItem_shouldBeSelected() {
        // Given
        let vm = UnitTestViewModel(isPremium: Bool.random())

        // When call selectItem
        let newItem = UUID().uuidString
        vm.addItem(item: newItem)
        vm.selectItem(item: newItem)

        // Then
        XCTAssertNotNil(vm.selectedItem)
        XCTAssertEqual(vm.selectedItem, newItem)
    }

    func test_UnitTestViewModel_selectedItem_shouldBeSelected_stress() {
        // Given
        let vm = UnitTestViewModel(isPremium: Bool.random())

        // When call selectItem
        let loopCount = Int.random(in: 1..<100)
        var itemArray: [String] = []
        for _ in 0..<loopCount {
            let newItem = UUID().uuidString
            vm.addItem(item: newItem)
            itemArray.append(newItem)
        }

        let randomItem = itemArray.randomElement() ?? ""
        XCTAssertFalse(randomItem.isEmpty)
        vm.selectItem(item: randomItem)

        // Then
        XCTAssertNotNil(vm.selectedItem)
        XCTAssertEqual(vm.selectedItem, randomItem)
    }

    func test_UnitTestViewModel_saveItem_shouldThrowError_itemNotFound() {
        // Given
        let vm = UnitTestViewModel(isPremium: Bool.random())

        // When call selectItem
        let loopCount = Int.random(in: 1..<100)
        var _: [String] = []
        for _ in 0..<loopCount {
            vm.addItem(item: UUID().uuidString)
        }

        // Then
        XCTAssertThrowsError(try vm.saveItem(item: UUID().uuidString))
        XCTAssertThrowsError(try vm.saveItem(item: UUID().uuidString), "Should throw Item Not Found") { error in
            let returnedError = error as? UnitTestViewModel.DataError
            XCTAssertEqual(returnedError, UnitTestViewModel.DataError.itemNotFound)
        }

    }

    func test_UnitTestViewModel_saveItem_shouldThrowError_noData() {
        // Given
        let vm = UnitTestViewModel(isPremium: Bool.random())

        // When call selectItem
        let loopCount = Int.random(in: 1..<100)
        var _: [String] = []
        for _ in 0..<loopCount {
            vm.addItem(item: UUID().uuidString)
        }

        // Then
        do {
            try vm.saveItem(item: "")
        } catch let error {
            let returnedError = error as? UnitTestViewModel.DataError
            XCTAssertEqual(returnedError, UnitTestViewModel.DataError.noData)
        }
    }

    func test_UnitTestViewModel_saveItem_shouldSaveItem() {
        // Given
        let vm = UnitTestViewModel(isPremium: Bool.random())

        // When call selectItem
        let loopCount = Int.random(in: 1..<100)
        var itemArray: [String] = []
        for _ in 0..<loopCount {
            let newItem = UUID().uuidString
            vm.addItem(item: newItem)
            itemArray.append(newItem)
        }

        let randomItem = itemArray.randomElement() ?? ""
        XCTAssertFalse(randomItem.isEmpty)
        // Then
        XCTAssertNoThrow(try vm.saveItem(item: randomItem))

        do {
            try vm.saveItem(item: randomItem)
        } catch {
            XCTFail()
        }
    }

    func test_UnitTestViewModel_downloadWithEscaping_shouldReturnItems() {
        // Given
        let vm = UnitTestViewModel(isPremium: Bool.random())

        // When call selectItem
        let expectation = XCTestExpectation(description: "Should return item after 3 seconds")
        vm.$dataArray
            .dropFirst()
            .sink { items in
                expectation.fulfill()
            }.store(in: &cancellable)
        vm.downloadWithEscaping()


        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
    }

    func test_UnitTestViewModel_downloadWithCombine_shouldReturnItems() {
        // Given
        let vm = UnitTestViewModel(isPremium: Bool.random())

        // When call selectItem
        let expectation = XCTestExpectation(description: "Should return item after a seconds")
        vm.$dataArray
            .dropFirst()
            .sink { items in
                expectation.fulfill()
            }.store(in: &cancellable)
        vm.downloadWithCombine()


        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
    }

    func test_UnitTestViewModel_downloadWithCombine_shouldReturnItems2() {
        // Given
        let items: [String] = [UUID().uuidString, UUID().uuidString, UUID().uuidString, UUID().uuidString, UUID().uuidString]
        let dataServices: NewDataServiceProtocol = NewMockDataService(items: items)
        let vm = UnitTestViewModel(isPremium: Bool.random(), dataService: dataServices)

        // When call selectItem
        let expectation = XCTestExpectation(description: "Should return item after a seconds")
        vm.$dataArray
            .dropFirst()
            .sink { items in
                expectation.fulfill()
            }.store(in: &cancellable)
        vm.downloadWithCombine()


        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
        XCTAssertEqual(vm.dataArray.count, items.count)
    }

}
