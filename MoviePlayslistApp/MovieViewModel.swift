//
//  MovieViewModel.swift
//  MoviePlayslistApp
//
//  Created by Raj Shekhar on 17/06/24.
//

import Foundation

protocol MoviesViewModelProtocol {
    var movies: [Movie] { get }
    var didUpdateMovies: (() -> Void)? { get set }
    func fetchMovies(completion: @escaping () -> Void)
    func addToPlaylist(movie: Movie, playlistName: String, completion: @escaping () -> Void)
    func filterMovies(by playlistName: String)
    func addNewPlaylist(named playlistName: String)
    func addToPlaylist(movie: Movie, playlistName: String, completion: @escaping (Result<Void, Error>) -> Void)
    func getPlaylists() -> [String]
    func getMovies(forPlaylist playlistName: String) -> [Movie]
}

class MoviesViewModel: MoviesViewModelProtocol {
    private(set) var movies: [Movie] = [] {
        didSet {
            didUpdateMovies?()
        }
    }
    private var playlists: [String: [Movie]] = [:]

    var didUpdateMovies: (() -> Void)?
    var movieService: MovieServiceProtocol
    
    init(movieService: MovieServiceProtocol = MovieService()) {
        self.movieService = movieService
    }
    
    func fetchMovies(completion: @escaping () -> Void) {
        movieService.fetchPopularMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
            case .failure(let error):
                print("Error fetching movies: \(error)")
            }
            completion()
        }
    }
    
    func addToPlaylist(movie: Movie, playlistName: String, completion: @escaping () -> Void) {
        movieService.addToPlaylist(movie: movie, playlistName: playlistName) { result in
            switch result {
            case .success:
                self.filterMovies(by: playlistName)
            case .failure(let error):
                print("Error adding to playlist: \(error)")
            }
            completion()
        }
    }
    
    func filterMovies(by playlistName: String) {
        self.movies = movieService.getMovies(forPlaylist: playlistName)
    }
    
    func addNewPlaylist(named playlistName: String) {
       //  Handle any logic needed to add a new playlist
       //  For simplicity, we'll assume playlists are managed in the MovieService
        //playlists[playlistName] =
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
