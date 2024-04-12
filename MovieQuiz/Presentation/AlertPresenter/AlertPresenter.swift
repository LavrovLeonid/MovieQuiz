//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Леонид Лавров on 3/17/24.
//

import UIKit

class AlertPresenter: AlertPresenterProtocol {
    // MARK: Properties
    weak var delegate: UIViewController?
    
    // MARK: Methods
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(title: alertModel.title, message: alertModel.message, preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = "Game results"
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.completion()
        }
        
        alert.addAction(action)
        
        delegate?.present(alert, animated: true, completion: nil)
    }
}
