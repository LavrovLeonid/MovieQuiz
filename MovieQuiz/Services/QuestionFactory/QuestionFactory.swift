//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Леонид Лавров on 3/14/24.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    // MARK: Private properties
    private let moviesLoader: MoviesLoaderProtocol
    private var movies: [MostPopularMovie] = []

    // MARK: Mock data
    //    private let questions: [QuizQuestion] = [
    //        QuizQuestion(
    //            image: "The Godfather",
    //            text: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: true),
    //        QuizQuestion(
    //            image: "The Dark Knight",
    //            text: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: true),
    //        QuizQuestion(
    //            image: "Kill Bill",
    //            text: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: true),
    //        QuizQuestion(
    //            image: "The Avengers",
    //            text: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: true),
    //        QuizQuestion(
    //            image: "Deadpool",
    //            text: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: true),
    //        QuizQuestion(
    //            image: "The Green Knight",
    //            text: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: true),
    //        QuizQuestion(
    //            image: "Old",
    //            text: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: false),
    //        QuizQuestion(
    //            image: "The Ice Age Adventures of Buck Wild",
    //            text: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: false),
    //        QuizQuestion(
    //            image: "Tesla",
    //            text: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: false),
    //        QuizQuestion(
    //            image: "Vivarium",
    //            text: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: false)
    //    ]
    
    // MARK: Properties
    weak var delegate: QuestionFactoryDelegate?
    
    // MARK: Lifecycle
    init(moviesLoader: MoviesLoaderProtocol) {
        self.moviesLoader = moviesLoader
    }
    
    // MARK: Methods
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            let randomIndexMovie = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: randomIndexMovie] else { return }
            
            let imageData = try? Data(contentsOf: movie.resizedImageURL)
            
            let randomQuestionRating = (5..<10).randomElement() ?? 0
            
            let rating = Float(movie.rating) ?? 0
            
            let question = QuizQuestion(
                image: imageData ?? Data(),
                text: "Рейтинг этого фильма больше чем \(randomQuestionRating)?",
                correctAnswer: rating > Float(randomQuestionRating)
            )
            
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
