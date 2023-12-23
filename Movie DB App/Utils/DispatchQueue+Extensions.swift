//
//  DispatchQueue+Extensions.swift
//  Movie DB App
//
//  Created by Trece on 23-12-23.
//

import Foundation

extension DispatchQueue {
    func asyncIfRequired(completionHandler: @escaping () -> Void) {
        if Thread.isMainThread {
            completionHandler()
            return
        }
        DispatchQueue.main.async {
            completionHandler()
        }
    }
}
