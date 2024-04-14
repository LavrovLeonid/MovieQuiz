//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Леонид Лавров on 4/14/24.
//

import Foundation
import UIKit

protocol MovieQuizPresenterProtocol {
    func convert(model: QuizQuestion) -> QuizStepViewModel
}

final class MovieQuizPresenter: MovieQuizPresenterProtocol {
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
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
}
