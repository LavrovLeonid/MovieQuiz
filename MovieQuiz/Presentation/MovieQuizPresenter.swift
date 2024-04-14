//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Леонид Лавров on 4/14/24.
//

import Foundation
import UIKit

protocol MovieQuizPresenterProtocol {
    var questionsAmount: Int { get }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel
    func setNextQuestion(question: QuizQuestion)
    func isLastQuestion() -> Bool
    func resetQuestionIndex()
    func switchToNextQuestion()
    func yesButtonTapped()
    func noButtonTapped()
}

final class MovieQuizPresenter: MovieQuizPresenterProtocol {
    
    // MARK: Properties
    
    let questionsAmount: Int = 10
    weak var viewController: MovieQuizViewController?
    
    // MARK: Private properties
    
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex: Int = 0
    
    // MARK: Methods
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    func setNextQuestion(question: QuizQuestion) {
        currentQuestion = question
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func yesButtonTapped() {
        didAnswer(isYes: true)
    }
    
    func noButtonTapped() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion, let viewController else { return }
        
        viewController.showAnswerResult(isCorrect: isYes == currentQuestion.correctAnswer)
    }
}
