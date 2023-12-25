//
//  UIView+Extensions.swift
//  Movie DB App
//
//  Created by Samuel on 25-12-23.
//

import UIKit

extension UIView {
    func addIndicatorToView() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .large
        activityIndicator.color = UIColor(named: "TextColor")
        addSubview(activityIndicator)
        DispatchQueue.main.asyncIfRequired {
            activityIndicator.startAnimating()
        }
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        return activityIndicator
    }
}

extension UIActivityIndicatorView {
    func removeIndicator() {
        DispatchQueue.main.asyncIfRequired { [weak self] in
            guard let self else { return }
            stopAnimating()
            superview?.alpha = 1
            removeFromSuperview()
        }
    }
}
