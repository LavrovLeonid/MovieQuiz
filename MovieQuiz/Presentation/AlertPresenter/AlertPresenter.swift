//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Леонид Лавров on 3/17/24.
//

import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    // MARK: Private properties
    
    private weak var viewController: ViewControllerAlertPresenterProtocol?
    
    // MARK: Initializator
    
    init(viewController: ViewControllerAlertPresenterProtocol?) {
        self.viewController = viewController
    }
    
    // MARK: Methods
    
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(title: alertModel.title, message: alertModel.message, preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = alertModel.accessibilityIdentifier
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.completion()
        }
        
        alert.addAction(action)
        
        viewController?.present(alert)
    }
}
