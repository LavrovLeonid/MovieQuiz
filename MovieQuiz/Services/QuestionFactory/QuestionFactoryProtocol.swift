//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Леонид Лавров on 3/15/24.
//

import Foundation

protocol QuestionFactoryProtocol {
    var delegate: QuestionFactoryDelegate? { get set }
    
    func requestNextQuestion()
}
