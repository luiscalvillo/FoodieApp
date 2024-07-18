//
//  Helpers.swift
//  Foodie
//
//  Created by Luis Calvillo on 7/18/24.
//

import UIKit

func open(url: URL) {
    if #available(iOS 10, *) {
        UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
            print("Open \(url): \(success)")
        })
    } else if UIApplication.shared.openURL(url) {
        print("Open \(url)")
    }
}
