//
//  MostPopularMoviesResponse.swift
//  MovieQuiz
//
//  Created by Леонид Лавров on 3/28/24.
//

import Foundation

struct MostPopularMoviesResponse: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}
