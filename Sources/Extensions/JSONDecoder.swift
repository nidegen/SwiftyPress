//
//  JSONDecoder.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import ZamzamKit

public extension JSONDecoder {
    
    static let `default` = JSONDecoder().with {
        $0.dateDecodingStrategy = .formatted(.iso8601)
    }
}

extension JSONDecoder {
    
    /// Returns a value of the type you specify, decoded from a JSON object.
    func decode<T>(_ type: T.Type, forResource name: String?, inBundle bundle: Bundle) throws -> T where T: Decodable {
        guard let url = bundle.url(forResource: name, withExtension: nil) else { throw DataError.nonExistent }
        
        do {
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            return try decode(type, from: data)
        } catch {
            throw DataError.parseFailure(error)
        }
    }
}
