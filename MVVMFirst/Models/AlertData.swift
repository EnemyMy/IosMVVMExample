//
//  AlertData.swift
//  MVVMFirst
//
//  Created by Алексей on 08.01.2021.
//

import UIKit

struct AlertData {
    
    typealias AlertStyle = UIAlertController.Style
    
    var title: String = ""
    var message: String = ""
    var style: AlertStyle = .alert
    var actions: [AlertAction] = []
    var textFields: [(UITextField) -> Void] = []
}

struct AlertAction {
    var title: String = ""
    var style: UIAlertAction.Style = .default
    var handler: (UIAlertAction) -> Void = { _ in }
}

extension AlertAction {
    static let defaultOkAction = AlertAction(title: "OK", style: .default, handler: { _ in })
    static let defaultCloseAction = AlertAction(title: "Close", style: .cancel, handler: { _ in })
}

extension AlertAction {
    func mapToUIAlertAction() -> UIAlertAction {
        UIAlertAction(title: self.title, style: self.style, handler: self.handler)
    }
}
