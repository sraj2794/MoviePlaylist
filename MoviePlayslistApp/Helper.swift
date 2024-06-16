//
//  Helper.swift
//  MoviePlayslistApp
//
//  Created by Raj Shekhar on 17/06/24.
//

import UIKit

extension UITableView {
    func showActivityIndicator(_ show: Bool) {
        var activityIndicator: UIActivityIndicatorView!
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: (self.frame.size.width/2), y: (self.frame.size.height * 0.7), width: 50, height: 50))
        if #available(iOS 13.0, *) {
            activityIndicator.style = .medium
        } else {
        }
        activityIndicator.color = UIColor.white
        activityIndicator.hidesWhenStopped = true
        if show {
            activityIndicator.startAnimating()
            self.backgroundView = activityIndicator
        } else {
            activityIndicator.stopAnimating()
            self.backgroundView = nil
        }
    }
}


extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: self.className, bundle: nil)
    }
}
