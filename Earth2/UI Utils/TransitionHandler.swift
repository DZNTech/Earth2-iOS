//
//  TransitionHandler.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-26.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit

class TransitionHandler : NSObject { }

extension TransitionHandler : UIViewControllerAnimatedTransitioning  {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.75
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from), let fromView = fromVC.view else { return }
        guard let toVC = transitionContext.viewController(forKey: .to), let toView = toVC.view else { return }
        let container = transitionContext.containerView

        let screenHeight = UIScreen.main.bounds.maxY
        let offScreenUp = CGAffineTransform(translationX: 0, y: -screenHeight)
        let offScreenDown = CGAffineTransform(translationX: 0, y: screenHeight)
        let screenIdentity = CGAffineTransform(translationX: 0, y: 0) //CGAffineTransform.identity

        fromView.transform = screenIdentity
        toView.transform = toVC.isBeingPresented ? offScreenDown : offScreenUp

        let isPresenting = toVC.isBeingPresented

        toVC.viewWillAppear(true)
        fromVC.viewWillDisappear(true)

        if isPresenting {
            container.addSubview(toView)
        } else {
            container.addSubview(fromView)
        }

        let duration = self.transitionDuration(using: transitionContext)

        DispatchQueue.main.async {
            UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseInOut], animations: {
                fromView.transform = toVC.isBeingPresented ? offScreenUp : offScreenDown
                toView.transform = screenIdentity
        }, completion: { finished in
                transitionContext.completeTransition(true)

            toVC.viewDidAppear(true)
            fromVC.viewDidDisappear(true)
        })
        }
    }
}

extension TransitionHandler : UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}
