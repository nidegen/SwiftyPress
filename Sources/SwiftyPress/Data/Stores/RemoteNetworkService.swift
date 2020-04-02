//
//  RemoteNetworkService.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-09.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import ZamzamCore

public struct RemoteNetworkService: RemoteService {
    private let networkRepository: NetworkRepositoryType
    private let jsonDecoder: JSONDecoder
    private let constants: ConstantsType
    private let log: LogRepositoryType
    
    public init(
        networkRepository: NetworkRepositoryType,
        jsonDecoder: JSONDecoder,
        constants: ConstantsType,
        log: LogRepositoryType
    ) {
        self.networkRepository = networkRepository
        self.jsonDecoder = jsonDecoder
        self.constants = constants
        self.log = log
    }
}

public extension RemoteNetworkService {
    
    func configure() {
        // No configure needed
    }
    
    func fetchModified(
        after date: Date?,
        with request: DataAPI.ModifiedRequest,
        completion: @escaping (Result<SeedPayloadType, DataError>) -> Void
    ) {
        let urlRequest: URLRequest = .modified(after: date, with: request, constants: constants)
        
        networkRepository.send(with: urlRequest) {
            guard case .success(let value) = $0 else {
                // Handle no modified data and return success
                if $0.error?.statusCode == 304 {
                    completion(.success(SeedPayload()))
                    return
                }
                
                self.log.error("An error occured while fetching the modified payload: \(String(describing: $0.error)).")
                completion(.failure(DataError(from: $0.error)))
                return
            }
            
            guard let data = value.data else {
                completion(.failure(.nonExistent))
                return
            }
            
            DispatchQueue.transform.async {
                do {
                    // Parse response data
                    let payload = try self.jsonDecoder.decode(SeedPayload.self, from: data)
                    DispatchQueue.main.async { completion(.success(payload)) }
                } catch {
                    self.log.error("An error occured while parsing the modified payload: \(error).")
                    DispatchQueue.main.async { completion(.failure(.parseFailure(error))) }
                    return
                }
            }
        }
    }
}

// MARK: - Requests

private extension URLRequest {
    
    static func modified(after: Date?, with request: DataAPI.ModifiedRequest, constants: ConstantsType) -> URLRequest {
        URLRequest(
            url: constants.baseURL
                .appendingPathComponent(constants.baseREST)
                .appendingPathComponent("modified"),
            method: .get,
            parameters: {
                var params: [String: Any] = [:]
                
                if let timestamp = after?.timeIntervalSince1970 {
                    params["after"] = Int(timestamp)
                }
                
                if !request.taxonomies.isEmpty {
                    params["taxonomies"] = request.taxonomies
                        .joined(separator: ",")
                }
                
                if !request.postMetaKeys.isEmpty {
                    params["meta_keys"] = request.postMetaKeys
                        .joined(separator: ",")
                }
                
                if let limit = request.limit {
                    params["limit"] = limit
                }
                
                return params
            }(),
            timeoutInterval: 30
        )
    }
}
