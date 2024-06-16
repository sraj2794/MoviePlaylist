//
//  MovieService.swift
//  MoviePlayslistApp
//
//  Created by Raj Shekhar on 17/06/24.
//

import Foundation

protocol MovieServiceProtocol {
    func fetchPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void)
    func addToPlaylist(movie: Movie, playlistName: String, completion: @escaping (Result<Void, Error>) -> Void)
    func getPlaylists() -> [String]
    func getMovies(forPlaylist playlistName: String) -> [Movie]
}

class MovieService: MovieServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    
    private var playlists: [String: [Movie]] = [:]
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
//    func fetchPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
//        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=38a73d59546aa378980a88b645f487fc") else {
//            return
//        }
//        
//        networkManager.makeRequest(url: url, completion: completion)
//    }
    
//    func fetchPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
//        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=38a73d59546aa378980a88b645f487fc") else {
//            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
//            completion(.failure(error))
//            return
//        }
//        
//        // Specify Q as [Movie].self when calling makeRequest
//        networkManager.makeRequest(url: url) { (result: Result<[Movie], Error>) in
//            completion(result)
//        }
//    }

    func fetchPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=38a73d59546aa378980a88b645f487fc") else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            completion(.failure(error))
            return
        }
        
        networkManager.makeRequest(url: url) { (result: Result<MovieResponse, Error>) in
            switch result {
            case .success(let movieResponse):
                completion(.success(movieResponse.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
    func addToPlaylist(movie: Movie, playlistName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if playlists[playlistName] != nil {
            playlists[playlistName]?.append(movie)
        } else {
            playlists[playlistName] = [movie]
        }
        completion(.success(()))
    }
    
    func getPlaylists() -> [String] {
        return Array(playlists.keys)
    }
    
    func getMovies(forPlaylist playlistName: String) -> [Movie] {
        return playlists[playlistName] ?? []
    }
}

extension URLRequest {
    
    /**
     Returns a cURL command representation of this URL request.
     */
    public var cURLString: String {
        guard let url = url else { return "" }
#if swift(>=5.0)
        var baseCommand = #"curl "\#(url.absoluteString)""#
#else
        var baseCommand = "curl \"\(url.absoluteString)\""
#endif
        
        if httpMethod == "HEAD" {
            baseCommand += " --head"
        }
        
        var command = [baseCommand]
        
        if let method = httpMethod, method != "GET" && method != "HEAD" {
            command.append("-X \(method)")
        }
        
        if let headers = allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key): \(value)'")
            }
        }
        
        if let data = httpBody, let body = String(data: data, encoding: .utf8) {
            command.append("-d '\(body)'")
        }
        
        return command.joined(separator: " \\\n\t")
    }
    
}
