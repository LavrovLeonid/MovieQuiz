//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Леонид Лавров on 3/16/24.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRequestNextQuestion()
    func didReceiveNextQuestion(question: QuizQuestion)
    func didRequestDataFromServer()
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
