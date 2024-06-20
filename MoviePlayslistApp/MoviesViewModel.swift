//
//  MoviesViewModel.swift
//  MoviePlayslistApp
//
//  Created by Raj Shekhar on 17/06/24.
//
import Foundation

protocol MoviesViewModelProtocol {
    var movies: [Movie] { get }
    var didUpdateMovies: (() -> Void)? { get set }
    var didUpdatePlaylists: (() -> Void)? { get set } // Add this for playlist updates
    func fetchMovies(completion: @escaping () -> Void)
    func addToPlaylist(movie: Movie, playlistName: String, completion: @escaping () -> Void)
    func filterMovies(by playlistName: String)
    func addNewPlaylist(named playlistName: String)
    func getPlaylists() -> [String]
}

class MoviesViewModel: MoviesViewModelProtocol {
    private(set) var movies: [Movie] = [] {
        didSet {
            didUpdateMovies?()
        }
    }
    
    private(set) var playlists: [String] = [] {
        didSet {
            didUpdatePlaylists?() // Notify when playlists are updated
        }
    }
    
    var didUpdateMovies: (() -> Void)?
    var didUpdatePlaylists: (() -> Void)?
    
    private var movieService: MovieServiceProtocol
    
    init(movieService: MovieServiceProtocol = MovieService()) {
        self.movieService = movieService
        self.playlists = movieService.getPlaylists() // Initialize playlists
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
        movieService.addToPlaylist(movie: movie, playlistName: playlistName) { [weak self] result in
            switch result {
            case .success:
                self?.filterMovies(by: playlistName)
            case .failure(let error):
                print("Error adding to playlist: \(error)")
            }
            completion()
        }
    }
    
    func filterMovies(by playlistName: String) {
        movies = movieService.getMovies(forPlaylist: playlistName)
    }
    
    func addNewPlaylist(named playlistName: String) {
        movieService.createPlaylist(named: playlistName) { [weak self] result in
            switch result {
            case .success:
                self?.playlists.append(playlistName) 
                print("Playlist created successfully")
            case .failure(let error):
                print("Error creating playlist: \(error)")
            }
        }
    }
    
    func getPlaylists() -> [String] {
        return playlists
    }
}
