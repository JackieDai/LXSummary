//
//  KioskCycleLayout.swift
//  LXSummary
//
//  Created by LingXiao Dai on 2023/7/31.
//

import UIKit

class KioskCycleLayout: UICollectionViewFlowLayout {

    var scale: CGFloat = 1 {
        didSet {
            if scale >= 1 {
                invalidateLayout()
            }
        }
    }

    override func prepare() {
        super.prepare()

        guard let collectionView else { return }

        switch scrollDirection {
        case .horizontal:
            let offset = (collectionView.frame.size.width - itemSize.width) * 0.5
            sectionInset = .init(top: 0, left: offset, bottom: 0, right: offset)

        case .vertical:
            let offset = (collectionView.frame.size.height - itemSize.height) * 0.5
            sectionInset = .init(top: offset, left: 0, bottom: offset, right: 0)
        @unknown default:
            fatalError("direction invalidation")
        }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard
            var attributes = super.layoutAttributesForElements(in: rect),
            let collectionView
        else {
            return nil
        }

        attributes.forEach { attri in
            var scale: CGFloat = 1
            var absOffset: CGFloat = 0
            let centerX = collectionView.bounds.size.width * 0.5 + collectionView.contentOffset.x
            let centerY = collectionView.bounds.size.height * 0.5 + collectionView.contentOffset.y

            if scrollDirection == .horizontal {

                absOffset = abs(attri.center.x - centerX)
                let distance = itemSize.width + minimumLineSpacing
                if absOffset < distance { /// 当前index
                    scale = (1 - absOffset / distance) * (self.scale - 1) + 1
                }
            } else {
                absOffset = abs(attri.center.y - centerY)
                let distance = itemSize.height + minimumLineSpacing
                if absOffset < distance {
                    scale = (1 - absOffset / distance) * (self.scale - 1) + 1
                }
            }

            attri.zIndex = Int(scale * 1000)
            attri.transform = CGAffineTransform(scaleX: scale, y: scale)
        }

        return attributes
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {

        var offset = proposedContentOffset
        guard let collectionView else { return offset }

        var minSpace = CGFloat.greatestFiniteMagnitude

        let centerX = offset.x + collectionView.bounds.size.width / 2
        let centerY = offset.y + collectionView.bounds.size.height / 2
        var visibleRect: CGRect
        if scrollDirection == .horizontal {
            visibleRect = CGRect(origin: CGPoint(x: offset.x, y: 0), size: collectionView.bounds.size)
        } else {
            visibleRect = CGRect(origin: CGPoint(x: 0, y: offset.y), size: collectionView.bounds.size)
        }
        if let attris = layoutAttributesForElements(in: visibleRect) {
            for attri in attris {
                if scrollDirection == .horizontal {
                    if abs(minSpace) > abs(attri.center.x - centerX) {
                        minSpace = attri.center.x - centerX
                    }
                } else {
                    if abs(minSpace) > abs(attri.center.y - centerY) {
                        minSpace = attri.center.y - centerY
                    }
                }
            }
        }
        if scrollDirection == .horizontal {
            offset.x += minSpace
        } else {
            offset.y += minSpace
        }

        return offset
    }
}
