//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Леонид Лавров on 3/17/24.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    var statistic: String {
        "\(correct)\\\(total) (\(date.dateTimeString))"
    }
    
    func isBetterThan(_ another: GameRecord) -> Bool {
        correct > another.correct
    }
}
