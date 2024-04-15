//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Леонид Лавров on 4/14/24.
//

import UIKit

final class MovieQuizPresenter {
    
    // MARK: Private properties
    
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var correctAnswers = 0
    private var currentQuestion: QuizQuestion?
    
    private var questionFactory: QuestionFactoryProtocol
    private var statisticService: StatisticServiceProtocol = StatisticService()
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    // MARK: Computed properties
    
    private var isLastQuestion: Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    // MARK: Initializator
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        let networkClient = NetworkClient()
        let moviesLoader = MoviesLoader(networkClient: networkClient)
        
        questionFactory = QuestionFactory(moviesLoader: moviesLoader)
        
        questionFactory.delegate = self
        
        questionFactory.loadData()
    }
    
    // MARK: Private methods
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion else { return }

        proceedWithAnswer(isCorrectAnswer: isYes == currentQuestion.correctAnswer)
    }

    private func proceedWithAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }

        viewController?.highlightImageBorder(isCorrectAnswer: isCorrectAnswer)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.proceedToNextQuestionOrResults()
        }
    }
    
    private func proceedToNextQuestionOrResults() {
        if isLastQuestion {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: "Ваш результат: \(correctAnswers)/\(questionsAmount)\n\(statisticService.getStatistic())", buttonText: "Сыграть ещё раз"
            )
            
            viewController?.show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            
            questionFactory.requestNextQuestion()
        }
    }
    
}

// MARK: MovieQuizPresenterProtocol

extension MovieQuizPresenter: MovieQuizPresenterProtocol {
    
    func yesButtonTapped() {
        didAnswer(isYes: true)
    }
    
    func noButtonTapped() {
        didAnswer(isYes: false)
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        
        questionFactory.requestNextQuestion()
    }
    
}

// MARK: QuestionFactoryDelegate

extension MovieQuizPresenter: QuestionFactoryDelegate {
    
    func didRequestNextQuestion() {
        viewController?.showLoadingIndicator()
    }
    
    func didReceiveNextQuestion(question: QuizQuestion) {
        viewController?.hideLoadingIndicator()
        
        currentQuestion = question
        
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func didRequestDataFromServer() {
        viewController?.showLoadingIndicator()
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        
        questionFactory.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.hideLoadingIndicator()
        
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
}
