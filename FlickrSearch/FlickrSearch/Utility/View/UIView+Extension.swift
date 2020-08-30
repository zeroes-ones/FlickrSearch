//
//  UIView+Extension.swift
//  FlickrSearch
//
//  Created by S on 8/30/20.
//  Copyright © 2020 Sandeep. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    /// Adds a subview with the specified constraints.
    ///
    /// - parameters:
    ///     - subview: The subview to add.
    ///     - top: The length the top of the subview is inset from the top of `self` (or the safe area).
    ///     - bottom: The length the bottom of the subview is inset from the bottom of `self` (or the safe area).
    ///     - leading: The length the leading edge of the subview is inset from the leading edge of `self` (or the safe area).
    ///     - trailing: The length the trailing edge of the subview is inset from the trailing edge of `self` (or the safe area).
    ///     - width: The width of the subview.  _May_ be omitted for self-sizing subviews.
    ///              **Must** be omitted when both `leading` and `trailing` are specified.
    ///     - height: The height of the subview.  _May_ be omitted for self-sizing subviews.
    ///              **Must** be omitted when both `top` and `bottom` are specified.
    ///     - constrainToSafeArea: Specifies that the subview should be inset from the safe area rather than `self`.
    ///
    /// - Note: When an inset is not provided for `top` or `bottom` the subview is vertically centered.
    /// - Note: When an inset is not provided for `leading` or `trailing` the subview is horizontally centered.
    func addConstrainedSubview(
        _ subview: UIView,
        top: CGFloat? = nil,
        bottom: CGFloat? = nil,
        leading: CGFloat? = nil,
        trailing: CGFloat? = nil,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        constrainToSafeArea: Bool = false
    ) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false

        let layoutGuide: LayoutGuide = constrainToSafeArea ? safeAreaLayoutGuide : self

        if let top = top {
            subview.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: top).isActive = true
        }
        if let bottom = bottom {
            subview.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: bottom).isActive = true
        }
        if top == nil && bottom == nil {
            subview.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor).isActive = true
        }
        if let leading = leading {
            subview.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: leading).isActive = true
        }
        if let trailing = trailing {
            subview.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: trailing).isActive = true
        }
        if leading == nil && trailing == nil {
            subview.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        }
        if let width = width {
            assert(leading == nil || trailing == nil)
            subview.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            assert(top == nil || bottom == nil)
            subview.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

private protocol LayoutGuide {
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
}
extension UIView: LayoutGuide {}
extension UILayoutGuide: LayoutGuide {}
