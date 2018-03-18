//
//  PopAnimator.swift
//  BeginnerCook
//
//  Created by 양원석 on 2018. 3. 18..
//  Copyright © 2018년 Razeware LLC. All rights reserved.
//

import UIKit

typealias Completion = () -> Void

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 1.0
    var presenting = true
    var originFrame = CGRect.zero
    
    var dismissCompletion: Completion?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to), let fromView = transitionContext.view(forKey: .from), let herbDetailsViewController = transitionContext.viewController(forKey: presenting ? .to : .from) as? HerbDetailsViewController else { return }
        
        let herbView = presenting ? toView : fromView
        
        let initialFrame = presenting ? originFrame : herbView.frame
        let finalFrame = presenting ? herbView.frame : originFrame
        
        let xScaleFactor = presenting ? initialFrame.width / finalFrame.width : finalFrame.width / initialFrame.width
        let yScaleFactor = presenting ? initialFrame.height / finalFrame.height : finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        if presenting {
            herbView.transform = scaleTransform
            herbView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            herbView.clipsToBounds = true
        }
        
        containerView.insertSubview(toView, belowSubview: herbView)
        herbDetailsViewController.containerView.alpha = self.presenting ? 0.0 : 1.0
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, animations: {
            herbView.transform = self.presenting ? .identity : scaleTransform
            herbView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            herbDetailsViewController.containerView.alpha = self.presenting ? 1.0 : 0.0
            herbView.layer.cornerRadius = self.presenting ? 0.0 : (20.0 / xScaleFactor)
        }, completion: { _ in
            if !self.presenting {
                self.dismissCompletion?()
            }
            transitionContext.completeTransition(true)
        })
        
        
    }

}
