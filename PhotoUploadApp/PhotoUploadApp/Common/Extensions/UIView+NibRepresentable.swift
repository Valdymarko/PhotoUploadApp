//
//  UIView+NibRepresentable.swift
//  PhotoUploadApp
//
//  Created by Volodymyr Ilkiv on 07.08.2022.
//

import Foundation
import UIKit

protocol NibRepresentable {
    static var nib: UINib { get }
    static var identifier: String { get }
}

extension UIView: NibRepresentable {
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    class var identifier: String {
        return String(describing: self)
    }
}

extension NibRepresentable where Self: UIView {
    static var viewFromNib: Self {
        return Bundle.main.loadNibNamed(
            Self.identifier,
            owner: nil, options: nil)?.first as! Self
    }
}

extension UIViewController: NibRepresentable {
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    class var identifier: String {
        return String(describing: self)
    }
}

protocol StoryboardInstantiatable {}

extension UIViewController: StoryboardInstantiatable {}

extension StoryboardInstantiatable where Self: NibRepresentable {
    static func instantiateFromStoryboard(name: String = Self.identifier) -> Self {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: Self.identifier)
        return vc as! Self
    }
}

protocol ViewControllerRepresentable: AnyObject {
    var view: UIView! { get }
}

extension UIViewController: ViewControllerRepresentable {}

extension UIStoryboard {
    var identifier: String {
        return String(describing: self)
    }
}
