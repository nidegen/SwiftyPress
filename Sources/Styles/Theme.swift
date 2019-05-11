//
//  Theme.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-06.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit

public protocol Theme {
    var tint: UIColor { get }
    var secondaryTint: UIColor { get }
    
    var backgroundColor: UIColor { get }
    var separatorColor: UIColor { get }
    var selectionColor: UIColor { get }
    var headerColor: UIColor { get }
    
    var labelColor: UIColor { get }
    var secondaryLabelColor: UIColor { get }
    var subtleLabelColor: UIColor { get }
    
    var buttonCornerRadius: CGFloat { get }
    
    var positiveColor: UIColor { get }
    var negativeColor: UIColor { get }
    
    #if os(iOS)
    var barStyle: UIBarStyle { get }
    var keyboardAppearance: UIKeyboardAppearance { get }
    
    func apply(for application: UIApplication)
    #else
    func apply()
    #endif
}
