//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Леонид Лавров on 3/17/24.
//

import Foundation

protocol StatisticServiceProtocol {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var totalQuestionsCount: Int { get }
    var correctQuestionsCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
    func getStatistic() -> String
}
