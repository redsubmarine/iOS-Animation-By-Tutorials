//
//  AnimatorFactory.swift
//  Widgets
//
//  Created by 양원석 on 2018. 4. 2..
//  Copyright © 2018년 Underplot ltd. All rights reserved.
//

import UIKit

class AnimatorFactory {
    
    static func scaleUp(view: UIView) -> UIViewPropertyAnimator {
        let scale = UIViewPropertyAnimator(duration: 0.33, curve: .easeIn)
        scale.addAnimations {
            view.alpha = 1.0
        }
        scale.addAnimations({
            view.transform = .identity
        }, delayFactor: 0.33)
        
        scale.addCompletion { _ in
            print("ready")
        }
        
        return scale
    }
    
    @discardableResult static func jiggle(view: UIView) -> UIViewPropertyAnimator {
        return UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.33, delay: 0, animations: {
            UIView.animateKeyframes(withDuration: 1, delay: 0, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25, animations: {
                    view.transform = CGAffineTransform(rotationAngle: -.pi / 8)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.75, animations: {
                    view.transform = CGAffineTransform(rotationAngle: .pi / 8)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 1, animations: {
                    view.transform = .identity
                })
                
            })
        }, completion: { _ in
            view.transform = .identity
        })
    }
    
    static func fade(view: UIView, visibble: Bool) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
            view.alpha = visibble ? 1.0 : 0.0
        })
    }
    
}
