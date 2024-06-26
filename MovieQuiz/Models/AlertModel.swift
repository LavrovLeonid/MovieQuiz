//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Леонид Лавров on 3/17/24.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let accessibilityIdentifier: String?
    let completion: () -> Void
}
