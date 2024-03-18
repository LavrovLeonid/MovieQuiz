//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Леонид Лавров on 3/17/24.
//

import UIKit

protocol AlertPresenterProtocol {
    var delegate: UIViewController? { get set }
    
    func show(alertModel: AlertModel)
}
