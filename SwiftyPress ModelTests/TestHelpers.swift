//
//  SwiftyPress_ModelTests.swift
//  SwiftyPress ModelTests
//
//  Created by Basem Emara on 2019-05-11.
//

import XCTest

extension Bundle {
    private class TempClassForBundle {}
    
    /// A representation of the code and resources stored in bundle directory on disk.
    static let test = Bundle(for: TempClassForBundle.self)
}
