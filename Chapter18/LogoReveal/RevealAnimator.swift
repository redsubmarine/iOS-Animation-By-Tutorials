//
//  RevealAnimator.swift
//  LogoReveal
//
//  Created by 양원석 on 2018. 3. 18..
//  Copyright © 2018년 Razeware LLC. All rights reserved.
//

import UIKit

class RevealAnimator: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    
    let duration = 2.0
    var operation: UINavigationControllerOperation = .push
    weak var storedContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        storedContext = transitionContext
        if operation == .push {
            guard let fromVC = transitionContext.viewController(forKey: .from) as? MasterViewController,
                let toVC = transitionContext.viewController(forKey: .to) as? DetailViewController else { return }
            transitionContext.containerView.addSubview(toVC.view)
            toVC.view.frame = transitionContext.finalFrame(for: toVC)
            
            let animation = CABasicAnimation(keyPath: "transform")
            animation.fromValue = CATransform3DIdentity
            animation.toValue = CATransform3DConcat(CATransform3DMakeTranslation(0.0, -10.0, 0.0), CATransform3DMakeScale(150.0, 150.0, 1.0))
            animation.duration = duration
            animation.delegate = self
            animation.fillMode = kCAFillModeForwards
            animation.isRemovedOnCompletion = false
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            
            let maskLayer = RWLogoLayer.logoLayer()
            maskLayer.position = fromVC.logo.position
            toVC.view.layer.mask = maskLayer
            maskLayer.add(animation, forKey: nil)
            
            fromVC.logo.add(animation, forKey: nil)
            
            let fadeIn = CABasicAnimation(keyPath: "opacity")
            fadeIn.duration = duration
            fadeIn.fromValue = 0.0
            fadeIn.toValue = 1.0
            toVC.view.layer.add(fadeIn, forKey: nil)
        } else {
            
            guard let fromView = transitionContext.view(forKey: .from),
                let toView = transitionContext.view(forKey: .to) else { return }
            transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
            
            UIView.animate(withDuration: duration, animations: {
                fromView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let context = storedContext,
            let fromVC = context.viewController(forKey: .from) as? MasterViewController,
            let toVC = context.viewController(forKey: .to) as? DetailViewController
            else {
                return
        }
        context.completeTransition(!context.transitionWasCancelled)
        storedContext = nil
        
        fromVC.logo.removeAllAnimations()
        toVC.view.layer.mask = nil
    }
}
