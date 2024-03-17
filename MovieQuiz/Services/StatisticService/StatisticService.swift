//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Леонид Лавров on 3/17/24.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    // MARK: Private properties
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case correctQuestionsCount, totalQuestionsCount, bestGame, gamesCount
    }
    
    // MARK: Properties
    var gamesCount: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.gamesCount.rawValue),
                  let count = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }
            
            return count
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить количество игр")
                return
            }
            
            userDefaults.set(data, forKey: Keys.gamesCount.rawValue)
        }
    }
    var totalQuestionsCount: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.totalQuestionsCount.rawValue),
                  let count = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }
            
            return count
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить общее количество вопросов")
                return
            }
            
            userDefaults.set(data, forKey: Keys.totalQuestionsCount.rawValue)
        }
    }
    var correctQuestionsCount: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.correctQuestionsCount.rawValue),
                  let count = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }
            
            return count
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить общее количество ответов")
                return
            }
            
            userDefaults.set(data, forKey: Keys.correctQuestionsCount.rawValue)
        }
    }
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить лучший результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    var totalAccuracy: Double {
        Double(correctQuestionsCount) / Double(totalQuestionsCount) * 100
    }
    
    // MARK: Methods
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        totalQuestionsCount += amount
        correctQuestionsCount += count
        
        let currentGame = GameRecord(correct: count, total: amount, date: Date())
        
        if currentGame.isBetterThan(bestGame) {
            bestGame = currentGame
        }
    }
    
    func getStatistic() -> String {
        """
        Количество сыгранных квизов: \(gamesCount)
        Рекорд: \(bestGame.statistic)
        Средняя точность: \(String(format: "%.2f", totalAccuracy))%
        """
    }
}
