//
//  Transition.swift
//  Video2Live
//
//  Created by Abayomi Ikuru on 14/03/2020.
//  Copyright © 2020 Abayomi Ikuru. All rights reserved.
//

import UIKit

class Transition: NSObject {
    
    var circle = UIView()
    var startingPoint = CGPoint.zero {
        didSet {
            circle.center = startingPoint
        }
    }
    
    var color = UIColor.systemOrange
    
    var duration = 0.3
    
    enum transitionMode: Int {
        case present, dismiss, pop
    }
    
    var transitionModeProperty:transitionMode = .present
    
}

extension Transition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containrview = transitionContext.containerView
        
        if transitionModeProperty == .present {
            
            if let presentView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
                let viewCenter = presentView.center
                let viewSize = presentView.frame.size
                
                circle = UIView()
                
                circle.frame = frameFor(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
                
                //hmm not sure if ill need this
                
                circle.layer.cornerRadius = circle.frame.size.height / 2
                circle.center = startingPoint
                circle.backgroundColor = color
                circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                containrview.addSubview(circle)
             
                //yup im pretty sure this won't be beneficial to me
                
                presentView.center = startingPoint
                presentView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                presentView.alpha = 0
                presentView.addSubview(presentView)
                
                UIView.animate(withDuration: duration, animations: {
                    self.circle.transform = CGAffineTransform.identity
                    presentView.transform = CGAffineTransform.identity
                    presentView.alpha = 1
                    presentView.center = viewCenter
                    
                }) { (success: Bool) in
                    transitionContext.completeTransition(success)
                }
                
            }
            
        }else{
            
            let transitionModeKey = (transitionModeProperty == .pop) ? UITransitionContextViewKey.to : UITransitionContextViewKey.from
            
            if let returningView = transitionContext.view(forKey: transitionModeKey) {
                let viewCenter = returningView.center
                let viewSize = returningView.frame.size
                
                circle.frame = frameFor(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
                circle.layer.cornerRadius = circle.frame.size.height / 2
                circle.center = startingPoint
                
                UIView.animate(withDuration: duration, animations: {
                    self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returningView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returningView.center = self.startingPoint
                    returningView.alpha = 0
                    
                    if self.transitionModeProperty == .pop {
                        containrview.insertSubview(returningView, belowSubview: returningView)
                        containrview.insertSubview(self.circle, belowSubview: returningView)
                    }
                    
                }) { (success) in
                    returningView.center = viewCenter
                    returningView.removeFromSuperview()
                    
                    self.circle.removeFromSuperview()
                    
                    transitionContext.completeTransition(success)
                }
                
            }
            
        }
        
    }
    
    
    func frameFor (withViewCenter viewCenter: CGPoint, size viewSize: CGSize, startPoint: CGPoint) -> CGRect {
        let xlength = fmax(startPoint.x, viewSize.width-startPoint.x)
        let ylength = fmax(startPoint.y, viewSize.height-startPoint.y)
        
        let offsetVector = sqrt(xlength * xlength + ylength * ylength) * 2
        let size = CGSize(width: offsetVector, height: offsetVector)
        
        return CGRect(origin: CGPoint.zero, size: size)
    }
    
}
