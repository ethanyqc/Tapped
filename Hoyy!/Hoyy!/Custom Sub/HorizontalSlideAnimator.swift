//
//  HorizontalSlideAnimator.swift
//  Hoyy!
//
//  Created by Ethan Chen on 1/5/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit

class HorizontalSlideAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    let duration = 0.9
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else{
            return
        }
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else{
            return
        }
        
        let container = transitionContext.containerView
        
        let screenOffRight = CGAffineTransform(translationX:-container.frame.width, y:0)
        let screenOffLeft = CGAffineTransform(translationX:container.frame.width, y:0)
        
        container.addSubview(fromView)
        container.addSubview(toView)
        
        toView.transform = screenOffRight
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
            fromView.transform = screenOffLeft
            fromView.alpha = 0.5
            toView.transform = CGAffineTransform.identity
            toView.alpha = 1
            
            
        }) { (success) in
            transitionContext.completeTransition(success)
        }
        
        
    }
    
}

