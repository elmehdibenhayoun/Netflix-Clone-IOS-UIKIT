//
//  Extensions.swift
//  Netflix Clone
//
//  Created by MAC on 14/8/2024.
//

import Foundation


extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
