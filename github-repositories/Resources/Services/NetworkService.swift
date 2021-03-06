//
//  NetworkService.swift
//  github-repositories
//
//  Created by vlsuv on 04.08.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation

enum NetworkServiceError: Error {
    case MissingHTTPResponce
    case StatusCodeError(_ statusCode: Int)
    case DataParseError
}

typealias NetworkServiceCompletionHandler = (Data?, URLResponse?, Error?) -> ()

enum NetworkServiceResult<T> {
    case Succes(T)
    case Failure(Error)
}

protocol NetworkServiceProtocol {
    var sessionConfiguration: URLSessionConfiguration { get }
    var session: URLSession { get }
    func fetchDataWith(request: URLRequest, completionHandler: @escaping NetworkServiceCompletionHandler) -> URLSessionDataTask?
    func fetch<T>(request: URLRequest, parse: @escaping (Data) -> (T)?, completionHandler: @escaping (NetworkServiceResult<T>) -> ())
}

extension NetworkServiceProtocol {
    func fetchDataWith(request: URLRequest, completionHandler: @escaping NetworkServiceCompletionHandler) -> URLSessionDataTask? {
        let dataTask = session.dataTask(with: request) { data, responce, error in
            if let error = error {
                completionHandler(nil, nil, error)
                return
            }
            
            guard let HTTPResponce = responce as? HTTPURLResponse else {
                let error = NetworkServiceError.MissingHTTPResponce
                completionHandler(nil, nil, error)
                return
            }
            
            switch HTTPResponce.statusCode {
            case 200:
                completionHandler(data, HTTPResponce, nil)
            default:
                let error = NetworkServiceError.StatusCodeError(HTTPResponce.statusCode)
                completionHandler(nil, HTTPResponce, error)
            }
        }
        return dataTask
    }
    
    func fetch<T>(request: URLRequest, parse: @escaping (Data) -> (T)?, completionHandler: @escaping (NetworkServiceResult<T>) -> ()) {
        let dataTask = fetchDataWith(request: request) { data, responce, error in
            guard let data = data else {
                if let error = error {
                    completionHandler(.Failure(error))
                }
                return
            }
            
            if let value = parse(data) {
                completionHandler(.Succes(value))
            } else {
                let error = NetworkServiceError.DataParseError
                completionHandler(.Failure(error))
            }
        }
        dataTask?.resume()
    }
}
