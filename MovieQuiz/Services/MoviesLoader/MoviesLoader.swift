//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Леонид Лавров on 3/28/24.
//

import Foundation

struct MoviesLoader: MoviesLoaderProtocol {
    // MARK: Private properties
    private let apiKey = "k_zcuw1ytf"
    private let networkClient: NetworkClientProtocol = NetworkClient()
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/\(apiKey)") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        
        return url
    }
    
    // MARK: Methods
    func loadMovies(handler: @escaping (Result<MostPopularMoviesResponse, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case let .success(data):
                do {
                    let mostPopularMoviesResponse = try JSONDecoder().decode(MostPopularMoviesResponse.self, from: data)
                    
                    handler(.success(mostPopularMoviesResponse))
                } catch {
                    handler(.failure(error))
                }
            case let .failure(error):
                handler(.failure(error))
            }
        }
    }
}
