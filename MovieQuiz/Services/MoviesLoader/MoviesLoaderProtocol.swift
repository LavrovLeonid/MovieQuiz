//
//  MoviesLoaderProtocol.swift
//  MovieQuiz
//
//  Created by Леонид Лавров on 3/28/24.
//

import Foundation

protocol MoviesLoaderProtocol {
    func loadMovies(handler: @escaping (Result<MostPopularMoviesResponse, Error>) -> Void)
}
