//
//  CenterPagingFlowLayout.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/02.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

final class CenterPagingFlowLayout: UICollectionViewFlowLayout {

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        centerPagingTargetContentOffset(for: proposedContentOffset)
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        centerPagingTargetContentOffset(for: proposedContentOffset)
    }

    private func centerPagingTargetContentOffset(for proposedContentOffset: CGPoint) -> CGPoint {
        guard let aCollectionView = collectionView else {
            return proposedContentOffset
        }

        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: aCollectionView.bounds.width, height: aCollectionView.bounds.height)

        if let attributes = layoutAttributesForElements(in: targetRect)?.first {
            let padding = (aCollectionView.bounds.width - attributes.bounds.width) * 0.5
            return CGPoint(x: attributes.frame.minX - padding, y: proposedContentOffset.y)
        }

        return proposedContentOffset
    }
}
