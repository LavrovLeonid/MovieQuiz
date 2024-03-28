//
//  NetworkClientProtocol.swift
//  MovieQuiz
//
//  Created by Леонид Лавров on 3/28/24.
//

import Foundation

protocol NetworkClientProtocol {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
