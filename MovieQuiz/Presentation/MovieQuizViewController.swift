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
    
    private var correctAnswers = 0
    
    private var questionFactory: QuestionFactoryProtocol = QuestionFactory(
        moviesLoader: MoviesLoader(
            networkClient: NetworkClient()
        )
    )
    private var alertPresenter: AlertPresenterProtocol = AlertPresenter()
    private var statisticService: StatisticServiceProtocol = StatisticService()
    
    private let presenter = MovieQuizPresenter()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertPresenter.delegate = self
        questionFactory.delegate = self
        
        presenter.viewController = self
        
        showLoadingIndicator()
        
        questionFactory.loadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonTapped()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonTapped()
    }
    
    // MARK: Methods
    
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.showNextQuestionOrResults()
        }
    }
    
    // MARK: Private methods
    
    private func show(quiz step: QuizStepViewModel) {
        stackView.isHidden = false
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        imageView.layer.borderWidth = 0
        
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) { [weak self] in
            guard let self else { return }
            
            presenter.resetQuestionIndex()
            
            correctAnswers = 0
            
            questionFactory.requestNextQuestion()
        }
        
        alertPresenter.show(alertModel: alertModel)
    }
    
    private func showNextQuestionOrResults() {
        if presenter.isLastQuestion() {
            statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)
            
            let quiz = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: "Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)\n\(statisticService.getStatistic())", buttonText: "Сыграть ещё раз"
            )
            
            show(quiz: quiz)
        } else {
            presenter.switchToNextQuestion()
            
            questionFactory.requestNextQuestion()
        }
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError(message: String) {
        let alertModel = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать ещё раз") { [weak self] in
            guard let self else { return }
            
            showLoadingIndicator()
            
            questionFactory.loadData()
        }
        
        alertPresenter.show(alertModel: alertModel)
    }
}

// MARK: - QuestionFactoryDelegate
extension MovieQuizViewController: QuestionFactoryDelegate {
    func didRequestNextQuestion() {
        showLoadingIndicator()
    }
    
    func didReceiveNextQuestion(question: QuizQuestion) {
        hideLoadingIndicator()
        
        presenter.setNextQuestion(question: question)
        
        show(quiz: presenter.convert(model: question))
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        
        questionFactory.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        hideLoadingIndicator()
        
        showNetworkError(message: error.localizedDescription)
    }
}
