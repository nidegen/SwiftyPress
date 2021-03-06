//
//  DataFileSeed.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation.NSBundle
import ZamzamCore

public struct DataFileSeed: DataSeed {
    private static var data: SeedPayload?
    
    private let name: String
    private let bundle: Bundle
    private let jsonDecoder: JSONDecoder
    
    public init(forResource name: String, inBundle bundle: Bundle, jsonDecoder: JSONDecoder) {
        self.name = name
        self.bundle = bundle
        self.jsonDecoder = jsonDecoder
    }
}

public extension DataFileSeed {
    
    func configure() {
        guard Self.data == nil else { return }
        
        Self.data = try? jsonDecoder.decode(
            SeedPayload.self,
            forResource: name,
            inBundle: bundle
        )
    }
}

public extension DataFileSeed {
    
    func fetch(completion: (Result<SeedPayload, SwiftyPressError>) -> Void) {
        completion(.success(Self.data ?? SeedPayload()))
    }
}

public extension DataFileSeed {
    
    func set(data: SeedPayload) {
        Self.data = data
    }
}
