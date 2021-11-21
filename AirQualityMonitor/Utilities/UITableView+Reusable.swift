//
//  UITableViewReusableExtension.swift
//  AirQualityMonitor
//
//  Created by Neha Goel on 22/11/21..
//

import UIKit

// MARK: - UITABLEVIEW
// Provides default implementations of generic reuse methods on UITableView to
// allow for consumers to register reuseable views for reuse such as UITableViewCells.
internal extension UITableView {
    
    func registerReusableCell<T: UITableViewCell>(_: T.Type) {
        if let nib = T.nib {
            self.register(nib, forCellReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func registerHeaderFooterView<T: UITableViewHeaderFooterView>(_ : T.Type) {
        if let nib = T.nib {
            self.register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T? {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath as IndexPath) as? T
    }
    
    func dequeueHeaderFooterView<T: UITableViewHeaderFooterView>() -> T? {
        return self.dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T
    }
}

// Represents a UIView that is a reuseable view such as a
// UITableViewCell, UITableViewHeaderFooterView or UITableViewCell.
// Provides everything necessary for a reusable view to be reused.
internal protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
    static var nib: UINib? { get }
}

// Provides default implementations of the necessary variables
// to reuse a generic view.
internal extension Reusable {
    static var reuseIdentifier: String { return String(describing: self) }
    static var nib: UINib? { return UINib(nibName: String(describing: self), bundle: nil) }
}

// Declares that all UITableReusableViews conform to the
// Reusable protocol and therefore gain the default
// implementation without any additional effort.
extension UITableViewCell: Reusable { }
extension UITableViewHeaderFooterView: Reusable { }
