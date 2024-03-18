//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Леонид Лавров on 3/16/24.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
