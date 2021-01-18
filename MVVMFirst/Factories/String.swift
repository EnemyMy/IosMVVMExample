//
//  String.swift
//  MVVMFirst
//
//  Created by Алексей on 18.01.2021.
//

import UIKit

extension String {
    static func create(_ text: String,
                       font: UIFont = UIFont.systemFont(ofSize: 12),
                       textColor: UIColor = .black) -> NSAttributedString {
        NSAttributedString(string: text, attributes: [
            NSAttributedString.Key.font : font,
            NSAttributedString.Key.foregroundColor : textColor
        ])
    }
}
