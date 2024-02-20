//
//  NetworkServices.swift
//  SmartMovie
//
//  Created by BachNguyen on 29/03/2023.
//

import Foundation

final class NetworkServices {
    private let session: URLSession
    private var dataTask: URLSessionDataTask?
    static func defaultSession() -> URLSession {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30.0
        let sesson = URLSession(configuration: config)
        return sesson
    }
    init(session: URLSession = NetworkServices.defaultSession()) {
        self.session = session
    }
}

extension NetworkServices: NetworkServicesProtocol {
    func request(info: RequestInfo, result: @escaping (Result<Data, NetworkServiceError>) -> Void) {
        dataTask = session.dataTask(with: info.urlInfo) { data, response, error in
            if let error = error?.localizedDescription {
                print(error)
                result(.failure(.serverError))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                result(.failure(.serverError))
                return
            }
            guard let data = data else {
                result(.failure(.noData))
                return
            }
            result(.success(data))
        }
        dataTask?.resume()
    }
}
