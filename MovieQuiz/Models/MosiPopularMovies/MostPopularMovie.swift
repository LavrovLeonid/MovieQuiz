//
//  MostPopularMovie.swift
//  MovieQuiz
//
//  Created by Леонид Лавров on 3/28/24.
//

import Foundation

struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageURL: URL
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}
