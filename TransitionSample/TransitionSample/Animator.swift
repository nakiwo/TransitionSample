//
//  Animator.swift
//  TransitionSample
//
//  Created by Yuichi Fujishige on 2015/09/18.
//  Copyright © 2015 Yuichi Fujishige. All rights reserved.
//

import UIKit

final class Animator : NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    private var presenting: Bool

    init(presenting: Bool) {
        self.presenting = presenting
        super.init()
    }

    // MARK: - UIViewControllerTransitioningDelegate

    func animationControllerForPresentedController(presented: UIViewController, presentingController presentingVC: UIViewController, sourceController sourceVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        assert(self.presenting == true)
        return self
    }

    func animationControllerForDismissedController(dismissedVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        assert(self.presenting == false)
        return self
    }

    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        assert(self.presenting == true)
        return nil
    }

    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        assert(self.presenting == false)
        return nil
    }

    // MARK: - UIViewControllerAnimatedTransitioning

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!

        var fromViewInitialFrame = transitionContext.initialFrameForViewController(fromVC)
        var fromViewFinalFrame = transitionContext.finalFrameForViewController(fromVC)

        var toViewInitialFrame = transitionContext.initialFrameForViewController(toVC)
        var toViewFinalFrame = transitionContext.finalFrameForViewController(toVC)

        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!

        let containerView = transitionContext.containerView()!

        var snapshotBottomBarView: UIView
        var snapshorFrame = fromView.bounds;
        snapshorFrame.size.height = RootViewController.bottomSpace
        snapshorFrame.origin.y = CGRectGetMaxY(fromView.bounds) - snapshorFrame.size.height

        if presenting {
            toViewInitialFrame = fromViewInitialFrame
            toViewInitialFrame.origin.y = fromViewInitialFrame.size.height - RootViewController.bottomSpace
            toView.frame = toViewInitialFrame

            containerView.addSubview(toView)

            snapshotBottomBarView = fromView.resizableSnapshotViewFromRect(snapshorFrame, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
            snapshorFrame.origin.y = CGRectGetMaxY(toView.bounds) - snapshorFrame.size.height
            snapshotBottomBarView.frame = snapshorFrame

            let rootVC = fromVC as! RootViewController
            rootVC.updateBottomSpaceForPresentation()
        } else {
            fromViewFinalFrame = fromViewInitialFrame
            fromViewFinalFrame.origin.y = fromViewInitialFrame.size.height - RootViewController.bottomSpace
            toView.frame = toViewFinalFrame

            containerView.insertSubview(toView, belowSubview: fromView)

            snapshotBottomBarView = toView.resizableSnapshotViewFromRect(snapshorFrame, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
            snapshorFrame.origin.y = CGRectGetMaxY(toView.bounds)
            snapshotBottomBarView.frame = snapshorFrame

            let rootVC = toVC as! RootViewController
            rootVC.updateBottomSpaceForDismissal()
        }

        containerView.addSubview(snapshotBottomBarView)

        UIView.animateWithDuration(
            self.transitionDuration(transitionContext),
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: UIViewAnimationOptions.TransitionNone,
            animations:  { [weak self] finished in
                if self!.presenting {
                    fromView.layoutIfNeeded()
                    toView.frame = toViewFinalFrame

                    snapshorFrame.origin.y = CGRectGetMaxY(fromView.bounds)
                    snapshotBottomBarView.frame = snapshorFrame
                } else {
                    fromView.frame = fromViewFinalFrame
                    toView.layoutIfNeeded()

                    snapshorFrame.origin.y = CGRectGetMaxY(toView.bounds) - snapshorFrame.size.height
                    snapshotBottomBarView.frame = snapshorFrame
                }
            },
            completion: { [weak self] finished in
                snapshotBottomBarView.removeFromSuperview()
                let success = !transitionContext.transitionWasCancelled()
                //let presenting = self!.presenting
                fromView.removeFromSuperview()
                transitionContext.completeTransition(success)
            }
        )
    }
}
