//
//  Extensions.swift
//  MC3-Practice
//
//  Created by Kim Insub on 2022/07/27.
//

import Foundation
import UIKit

extension UICollectionViewCell {

    static var identifier: String {
        NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last!
    }
}
