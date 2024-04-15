//
//  MovieQuizViewController.swift
//  MovieQuiz
//
//  Created by Леонид Лавров on 4/14/24.
//

import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var stackView: UIStackView!
    
    // MARK: Private properties
    
    private var alertPresenter: AlertPresenterProtocol!
    private var presenter: MovieQuizPresenterProtocol!
    
    // MARK: Overrides
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertPresenter = AlertPresenter(viewController: self)
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    // MARK: Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonTapped()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonTapped()
    }
    
}

// MARK: MovieQuizViewControllerProtocol

extension MovieQuizViewController: MovieQuizViewControllerProtocol {
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        stackView.isHidden = false
        imageView.layer.borderWidth = 0
        
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            accessibilityIdentifier: "Game results"
        ) { [weak self] in
            self?.presenter.restartGame()
        }
        
        alertPresenter.show(alertModel: alertModel)
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        let alertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз",
            accessibilityIdentifier: "Network Error"
        ) { [weak self] in
            self?.presenter.restartGame()
        }
        
        alertPresenter.show(alertModel: alertModel)
    }
    
}

// MARK: ViewControllerAlertPresenterProtocol

extension MovieQuizViewController: ViewControllerAlertPresenterProtocol {
    
    func present(_ alert: UIAlertController) {
        present(alert, animated: true)
    }
    
}
