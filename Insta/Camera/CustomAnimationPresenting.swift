//
//  CustomAnimationPresenting.swift
//  Insta
//
//  Created by Mostafa Adel on 6/28/20.
//  Copyright © 2020 Mostafa Adel. All rights reserved.
//

import UIKit
class CustomAnimationPresenting : NSObject , UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let contanirView = transitionContext.containerView
        guard  let toView = transitionContext.view(forKey: .to) else{return}
        guard let fromView = transitionContext.view(forKey: .from) else {return}
        contanirView.addSubview(toView)
        let startAnimation  = CGRect(x: -toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
        toView.frame = startAnimation
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
            fromView.frame = CGRect(x: fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
            
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
    
    
    
    
}
