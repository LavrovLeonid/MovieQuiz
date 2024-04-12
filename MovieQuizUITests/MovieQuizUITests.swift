//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Леонид Лавров on 4/12/24.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testNoButton() {
        sleep(3)
        
        let firstPosterData = app.images["Poster"].screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        
        sleep(3)
        
        let secondPosterData = app.images["Poster"].screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"].label
        
        XCTAssertEqual(indexLabel, "2/10")
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    
    func testYesButton() {
        sleep(3)
        
        let firstPosterData = app.images["Poster"].screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        
        sleep(3)
        
        let secondPosterData = app.images["Poster"].screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"].label
        
        XCTAssertEqual(indexLabel, "2/10")
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    
    func testResultAlert() {
        sleep(2)
        
        for index in 1...10 {
            let indexLabel = app.staticTexts["Index"].label
            
            app.buttons["Yes"].tap()
            
            sleep(2)
            
            XCTAssertEqual(indexLabel, "\(index)/10")
        }
        
        let alert = app.alerts["Game results"]
        
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть ещё раз")
    }
    
    func testDismissResultAlert() {
        sleep(2)
        
        for index in 1...10 {
            let indexLabel = app.staticTexts["Index"].label
            
            app.buttons["Yes"].tap()
            
            sleep(2)
            
            XCTAssertEqual(indexLabel, "\(index)/10")
        }
        
        let alert = app.alerts["Game results"]
        
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"].label
        
        XCTAssertFalse(alert.exists)
        XCTAssertEqual(indexLabel, "1/10")
    }
}
