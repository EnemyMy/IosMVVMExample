//
//  UICollectionView.swift
//  MVVMFirst
//
//  Created by Алексей on 17.01.2021.
//

import UIKit

extension UICollectionView {
    func register<Cell: UICollectionViewCell>(_ cellClass: Cell.Type) {
        self.register(cellClass, forCellWithReuseIdentifier: cellClass.description())
    }

    func deque<Cell: UICollectionViewCell>(_ cellClass: Cell.Type, for indexPath: IndexPath) -> Cell? {
        self.dequeueReusableCell(withReuseIdentifier: cellClass.description(), for: indexPath) as? Cell
    }
}

extension UICollectionViewCell {
    /// Call this method from `prepareForReuse`, because the cell needs to be already rendered (and have a size) in order for this to work
    func shadowDecorate(radius: CGFloat = 8,
                        shadowColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3),
                        shadowOffset: CGSize = CGSize(width: 0, height: 1.0),
                        shadowRadius: CGFloat = 3,
                        shadowOpacity: Float = 1) {
        contentView.layer.cornerRadius = radius
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true

        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        layer.cornerRadius = radius
    }
}
