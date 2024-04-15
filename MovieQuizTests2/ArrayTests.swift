//
//  ArrayTests.swift
//  MovieQuizTests2
//
//  Created by Леонид Лавров on 4/12/24.
//

import XCTest
@testable import MovieQuiz

final class ArrayTests: XCTestCase {
    func testGetValueInRange() throws { // тест на успешное взятие элемента по индексу
        // Given
        let array = [1, 1, 2, 3, 5]
        
        // When
        let value = array[safe: 2]
        
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
}
