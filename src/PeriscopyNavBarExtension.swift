//
//  PeriscopyNavBarExtension.swift
//  PeriscopyPullToRefresh
//
//  Created by Andrzej Naglik on 02.09.2015.
//  Copyright © 2015 Andrzej Naglik. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
  private func stripeImage() -> UIImage {
    UIGraphicsBeginImageContextWithOptions(CGSize(width: 32, height: 44), false, 0)
    let context = UIGraphicsGetCurrentContext()
    
    // Gradient
    let gradientColors = [UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 0.0800).cgColor, UIColor.clear.cgColor] as CFArray
    let gradientObject = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: [0,0.89])
    
    guard let ctx = context, let gradient = gradientObject else {
        return UIImage()
    }
    
    // Bezier
    let bezierPath = UIBezierPath()
    bezierPath.move(to: CGPoint(x: 0.0, y: 44.0))
    bezierPath.addLine(to: CGPoint(x: 18.5, y: 0.0))
    bezierPath.addLine(to: CGPoint(x: 31.5, y: 0.0))
    bezierPath.addLine(to: CGPoint(x: 13.5, y: 44.0))
    bezierPath.addLine(to: CGPoint(x: 0.0, y: 44.0))
    bezierPath.close()
    ctx.saveGState()
    bezierPath.addClip()
    ctx.drawLinearGradient(gradient, start: CGPoint(x: -2.5, y: 40.5), end: CGPoint(x: 34.5, y: 3.5),
                           options: CGGradientDrawingOptions())
    ctx.restoreGState()
    let imageToReturn = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return imageToReturn!
  }
  
  
  func startLoadingPeriscopyAnimation() -> UIView {
    let image = stripeImage()
    let extraWidth = (image.size.width) * 8 //adding 8 additional stripes
    
    let animatedView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.width + extraWidth, height: self.frame.height))
    animatedView.backgroundColor = UIColor(patternImage: image)
    animatedView.isOpaque = false
    
    self.insertSubview(animatedView, at: 1)
    
    UIView.animate(withDuration: 2.0, delay: 0.0, options: [.repeat, .curveLinear] , animations: {
        animatedView.frame.origin.x -= extraWidth
    }, completion: nil)
    
    return animatedView
  }
  
  func stopLoadingPeriscopyAnimationWithView(_ view: UIView){
    UIView.animate(withDuration: 1.0, animations: {
        view.alpha = 0.0
    }, completion: { [weak view] (completed) -> Void in
        if let animatedView = view{
            animatedView.layer.removeAllAnimations()
            animatedView.removeFromSuperview()
        }
    })
  }
}
