//
//  RootViewController.swift
//  TransitionSample
//
//  Created by Yuichi Fujishige on 2015/09/18.
//  Copyright © 2015 Yuichi Fujishige. All rights reserved.
//

import UIKit

final class RootViewController: UIViewController, UIViewControllerTransitioningDelegate {

    static let bottomSpace:CGFloat = 49

    private var animator: Animator?

    @IBOutlet private weak var barBottomSpace: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateBottomSpaceForDismissal()
    }

    @IBAction func backToRootAction(segue: UIStoryboardSegue) {
        animator = Animator(presenting: false)
        segue.sourceViewController.transitioningDelegate = animator
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showModal" {
            //segue.destinationViewController.modalPresentationStyle = .FullScreen // not .Custom
            animator = Animator(presenting: true)
            segue.destinationViewController.transitioningDelegate = animator
        }
    }

    func updateBottomSpaceForPresentation() {
        barBottomSpace.constant = self.view.bounds.size.height
    }

    func updateBottomSpaceForDismissal() {
        barBottomSpace.constant = RootViewController.bottomSpace
    }
}

