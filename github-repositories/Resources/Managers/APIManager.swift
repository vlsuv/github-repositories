//
//  APIManager.swift
//  github-repositories
//
//  Created by vlsuv on 04.08.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation

enum APIManagerError: Error {
    case IncorrentRequestError
}

enum APIEndpoint {
    static let baseURL: URL = URL(string: "https://api.github.com/users")!
    
    case repositories(user: String)
    
    var path: String {
        switch self {
        case .repositories(user: let user):
            return "/\(user)/repos"
        }
    }
    
    var request: URLRequest {
        switch self {
        case .repositories(user: _):
            let url = APIEndpoint.baseURL.appendingPathComponent(path)
            
            return URLRequest(url: url)
        }
    }
}

protocol APIManagerProtocol {
    func fetchRepositories(for user: String, completion: @escaping ((NetworkServiceResult<[Repository]>) -> ()))
}

class APIManager: NetworkServiceProtocol, APIManagerProtocol {
    
    // MARK: - Properties
    var sessionConfiguration: URLSessionConfiguration
    
    var session: URLSession {
        return URLSession(configuration: sessionConfiguration)
    }
    
    // MARK: - Init
    init(sessionConfiguration: URLSessionConfiguration = .default) {
        self.sessionConfiguration = sessionConfiguration
    }
    
    // MARK: - User
    func fetchRepositories(for user: String, completion: @escaping ((NetworkServiceResult<[Repository]>) -> ())) {
        let request = APIEndpoint.repositories(user: user).request
        
        fetch(request: request, parse: { (data) -> ([Repository])? in
            guard let value = try? JSONDecoder().decode([Repository].self, from: data) else { return nil }
            
            return value
        }, completionHandler: completion)
    }
}
