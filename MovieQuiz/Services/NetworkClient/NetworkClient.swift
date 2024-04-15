//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Леонид Лавров on 3/28/24.
//

import Foundation

struct NetworkClient: NetworkClientProtocol {
    
    // MARK: Private structs
    
    private enum NetworkError: Error {
        case codeError
    }
    
    // MARK: Methods
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                handler(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            if let data {
                handler(.success(data))
            }
        }
        
        task.resume()
    }
    
}
