//
//  RepositoryInfoViewAnimator.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/02.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

final class RepositoryInfoViewAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private let duration = 0.35
    let isPresenting: Bool

    init(presenting: Bool) {
        self.isPresenting = presenting

        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to)
        else {
            print("Cannot retreive from and to viewControllers")
            transitionContext.completeTransition(false)
            return
        }

        toViewController.view.layoutIfNeeded()

        guard
            let fromSourceView = (fromViewController as? TransitionSourceViewProvidable)?.sourceView(for: self),
            let toSourceView = (toViewController as? TransitionSourceViewProvidable)?.sourceView(for: self)
        else {
            print("Cannot retreive from and to source views")
            transitionContext.completeTransition(false)
            return
        }

        let fromSnapshotView = fromSourceView.snapshotLayer()
        copyShadowConfig(fromSourceView, to: fromSnapshotView)

        let containerView = transitionContext.containerView
        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        // ugly hack, toSourceView.frame がずれてしまうのために offset してる。
        // safeAreaInset.top 分ズレる。
        let offset = (toViewController as? TransitionSourceViewProvidable)?.sourceViewFrameOffset ?? .zero
        let fromFrame = containerView.convert(fromSourceView.frame, from: fromSourceView.superview)
        let toFrame = containerView.convert(toSourceView.frame, from: toSourceView.superview).offsetBy(dx: offset.x, dy: offset.y)

        fromSnapshotView.frame = fromFrame
        containerView.addSubview(fromSnapshotView)

        containerView.backgroundColor = .systemBackground
        toViewController.view.alpha = 0
        fromSourceView.isHidden = true
        (toViewController as? RepositoryDetailViewController)?.updateVisibleCellCloseButtonVisibility(false, animating: false)

        UIView.animateKeyframes(withDuration: duration, delay: .zero, options: []) {

            if self.isPresenting {
                UIView.addKeyframe(withRelativeStartTime: .zero, relativeDuration: 0.6) {
                    fromSnapshotView.frame = toFrame
                }

                UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.6) {
                    fromViewController.view.alpha = 0
                }

                UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.4) {
                    toViewController.view.alpha = 1
                }
            } else {
                UIView.addKeyframe(withRelativeStartTime: .zero, relativeDuration: 0.6) {
                    fromSnapshotView.frame = toFrame
                }

                UIView.addKeyframe(withRelativeStartTime: .zero, relativeDuration: 0.2) {
                    fromViewController.view.alpha = 0
                }

                UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.5) {
                    toViewController.view.alpha = 1
                }
            }
        } completion: { (_) in
            fromSourceView.isHidden = false
            fromSnapshotView.removeFromSuperview()
            fromViewController.view.removeFromSuperview()
            fromViewController.view.alpha = 1
            transitionContext.completeTransition(true)
            (toViewController as? RepositoryDetailViewController)?.updateVisibleCellCloseButtonVisibility(true, animating: true)
        }
    }

    private func copyShadowConfig(_ from: UIView, to: UIView) {
        to.layer.shadowColor = from.layer.shadowColor
        to.layer.shadowOffset = from.layer.shadowOffset
        to.layer.shadowRadius = from.layer.shadowRadius
        to.layer.shadowOpacity = from.layer.shadowOpacity
    }
}
