//
//  NetworkManager.swift
//  MoviePlayslistApp
//
//  Created by Raj Shekhar on 17/06/24.
//

import Foundation

protocol NetworkManagerProtocol {
    func makeRequest<Q: Codable>(url: URL, completion: @escaping (Result<Q, Error>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    func makeRequest<Q: Codable>(url: URL, completion: @escaping (Result<Q, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            let urlRequest = URLRequest(url: url)
            print(urlRequest.cURLString)

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(Q.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
