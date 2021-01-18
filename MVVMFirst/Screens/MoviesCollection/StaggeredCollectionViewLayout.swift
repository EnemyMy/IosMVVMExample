//
//  StaggeredCollectionViewLayout.swift
//  MVVMFirst
//
//  Created by Алексей on 17.01.2021.
//

import UIKit

protocol StaggeredCollectionViewLayoutDelegate {
    func numberOfColumnsInCollectionView(_ collectionView: UICollectionView) -> Int
    func lineSpacingInCollectionView(_ collectionView: UICollectionView) -> Int
    func interitemSpacingInCollectionView(_ collectionView: UICollectionView) -> Int
}

class StaggeredCollectionViewLayout: UICollectionViewLayout {
    
    var delegate: StaggeredCollectionViewLayoutDelegate?
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset.left + collectionView.contentInset.right
        return collectionView.bounds.width - insets
    }
    
    private var contentHeight: CGFloat = 0
    
    override var collectionViewContentSize: CGSize {
        CGSize(width: contentWidth, height: contentHeight)
    }
    
    private var numberOfColumns: Int {
        guard let collectionView = collectionView,
              let delegate = delegate
        else { return 0 }
        return delegate.numberOfColumnsInCollectionView(collectionView)
    }
    
    private var columnWidth: CGFloat {
        contentWidth / CGFloat(numberOfColumns)
    }
    
    private var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    
    override func prepare() {
        guard let delegate = delegate,
              let collectionView = collectionView
        else { return }
        
        layoutAttributes.removeAll()
        
        let xPadding = delegate.interitemSpacingInCollectionView(collectionView)
        let yPadding = delegate.lineSpacingInCollectionView(collectionView)
        
        var xOffsets: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffsets.append(CGFloat(column) * columnWidth)
        }
        
        var yOffsets: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        var currentColumn = 0
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let xPos = xOffsets[currentColumn]
            let yPos = yOffsets[currentColumn]
            let width = columnWidth
            let height = Int.random(in: 150...400)
            let frame = CGRect(x: xPos, y: yPos, width: width, height: CGFloat(height))
            
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attr.frame = frame.insetBy(dx: CGFloat(xPadding), dy: CGFloat(yPadding))
            layoutAttributes.append(attr)
            
            yOffsets[currentColumn] += CGFloat(height)
            contentHeight = max(contentHeight, frame.maxY)
            currentColumn = getCurrentColumn(yOffsets: yOffsets)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleElements: [UICollectionViewLayoutAttributes] = []
        for attr in layoutAttributes {
            if attr.frame.intersects(rect) {
                visibleElements.append(attr)
            }
        }
        return visibleElements
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        layoutAttributes[indexPath.item]
    }
    
    // Need to call after contentHeight is updated
    private func getCurrentColumn(yOffsets: [CGFloat]) -> Int {
        var result = 0
        for index in 0..<yOffsets.count {
            if contentHeight - yOffsets[index] > 400 {
                result = index
                break
            }
        }
        return result
    }
}
