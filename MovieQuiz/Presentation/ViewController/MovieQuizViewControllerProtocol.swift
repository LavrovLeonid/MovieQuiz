//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Леонид Лавров on 4/14/24.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
}
